// 'Sticky' beams, in the spirit of a scorpian web projectile, but not based on it in any way other than concept
class SeekerTractorBeam extends Projectile;

var Emitter WaveEffect;
var M_Seeker SpawningSeeker;
var emitter TractorBeam;
var int AccelFactor;
var int TractorFactor;
var int InfluenceRadius;
var bool bInitialized;

replication
{
	reliable if (Role == ROLE_Authority && bNetInitial)
		SpawningSeeker;
}

simulated function Destroyed()
{
	if ( WaveEffect != None )
		WaveEffect.Destroy();
	if ( TractorBeam != None )
		TractorBeam.Destroy();
    Super.Destroyed();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Velocity = Vector(Rotation);
	Acceleration = Velocity;
    Velocity *= Speed;

	SetTimer(1.5,false);
}

simulated function Tick(float DeltaTime)
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		if (!bInitialized)
		{
			if (SpawningSeeker != None)
			{
				bInitialized = true;
				WaveEffect = Spawn(class'SeekerTractorBeamEmitter', self);
				TractorBeam = Spawn(Class'SeekerTractorBeamFX');

				SpawningSeeker.attachToBone(WaveEffect, 'TailTip');
				WaveEffect.setRelativeLocation(vect(0, 0, 0));
				WaveEffect.setRelativeRotation(rot(0, 0, 0));
				
				SpawningSeeker.attachToBone(TractorBeam, 'TailTip');
				TractorBeam.setRelativeLocation(vect(0, 0, 0));
				TractorBeam.setRelativeRotation(rot(0, 0, 0));	
			}
		}
		else if (TractorBeam != None)
		{	
			if (VSize(Velocity) < MaxSpeed)
				Acceleration += Normal(Velocity) * (AccelFactor * deltaTime);
					
			BeamEmitter(TractorBeam.Emitters[0]).BeamEndPoints[0].Offset.X.Min = Location.X;
			BeamEmitter(TractorBeam.Emitters[0]).BeamEndPoints[0].Offset.X.Max = Location.X;
			BeamEmitter(TractorBeam.Emitters[0]).BeamEndPoints[0].Offset.Y.Min = Location.Y;
			BeamEmitter(TractorBeam.Emitters[0]).BeamEndPoints[0].Offset.Y.Max = Location.Y;
			BeamEmitter(TractorBeam.Emitters[0]).BeamEndPoints[0].Offset.Z.Min = Location.Z;
			BeamEmitter(TractorBeam.Emitters[0]).BeamEndPoints[0].Offset.Z.Max = Location.Z;
		}
	}
}

simulated function Timer()
{
	Disable('Tick');
	Destroy();
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ((Pawn(Other) != None) && (PlayerController(Pawn(Other).Controller) != None))
	{
		SetTimer(1.5,false);
		if (Role == ROLE_Authority)
			GrapplePlayer(Other,true);
		SetPhysics(PHYS_None);
		self.SetBase(Other);
	}
}

function GrapplePlayer(actor Other, optional bool bDirectHit)
{
	Local vector KbMomentum;
		
	KbMomentum = SpawningSeeker.Location - Other.Location;
	KbMomentum = Normal(KbMomentum);
	if (bDirectHit)
		KbMomentum *= 1.8 * TractorFactor;
	else
		KbMomentum *= TractorFactor;
	Pawn(Other).AddVelocity(KbMomentum);
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}
simulated function HitWall(vector HitNormal, Actor HitWall)
{
	Explode(Location,HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local pawn P;
	
	PlaySound(ImpactSound, SLOT_Misc);
		if (Role == ROLE_Authority)
			foreach VisibleCollidingActors( class 'Pawn', P, InfluenceRadius)
				if (!FastTrace(P.Location))
					GrapplePlayer(P);	
	Destroy();
}

defaultproperties
{
     AccelFactor=2000
     TractorFactor=8000
     InfluenceRadius=250
     Speed=3000.000000
     MaxSpeed=15000.000000
     ImpactSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     LifeSpan=5.000000
     DrawScale=5.000000
     SoundVolume=255
     SoundRadius=100.000000
     bProjTarget=True
}
