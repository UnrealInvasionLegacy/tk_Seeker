// The Seeker is modeled after the Kraken from the SpecialSkaarjPack (which is a tentacle from Satori)
// but uses an all new model (that doesn't look like a flying pizza)
// and animations created by Bio.
class M_Seeker extends tk_Monster;

var sound Echo, Victory;
var int		TakingOff;
var bool 	bInitialized;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if (Role == ROLE_Authority)
		SetTimer(1.5,true);
}

function Timer()
{
	if (!bInitialized)
	{
		bInitialized = true;
		TakeOff();
		SetTimer(1.0,true);
	}

	if (TakingOff == 0)
	{
		if (Physics == PHYS_Walking)
		{
			if (frand() < 0.25)
				TakeOff();
		}
		else if (Physics == PHYS_Flying)
		{
			if (!FastTrace(Location + (-250 * vect(0,0,1))))
			{
				SetPhysics(PHYS_Falling);
				SetAnimAction('Land');
			}
		}		
	}
	else
	{
		TakingOff++;
		if (TakingOff == 5)
			TakingOff = 0;	
	}

}	

function TakeOff()
{
	TakingOff = 1;
	AddVelocity((Location - (Location + (CollisionHeight) * vect(0,0,1)))*-40);
	TweenAnim('TakeOff',0.5);
	SetPhysics(PHYS_Flying);
}

function bool SameSpeciesAs(Pawn P)
{
	if (P.Controller.IsA('FriendlyMonsterController'))
		return false;
	else
		return (Monster(P) != None);
}

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	local vector X,Y,Z,duckdir;

    GetAxes(Rotation,X,Y,Z);
	if (DoubleClickMove == DCLICK_Forward)
		duckdir = X;
	else if (DoubleClickMove == DCLICK_Back)
		duckdir = -1*X;
	else if (DoubleClickMove == DCLICK_Left)
		duckdir = Y;
	else if (DoubleClickMove == DCLICK_Right)
		duckdir = -1*Y;

	SetPhysics(PHYS_Flying);
	
	Controller.Destination = Location + 200 * duckDir;
	Velocity = AirSpeed * duckDir;
	Controller.GotoState('TacticalMove', 'DoMove');
	return true;
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	if ( bShotAnim )
		return;

	TweenAnim('PlayHit',0.5);
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if ( FRand() < 0.5 )
		PlayAnim('Death1',, 0.1);
	else
		PlayAnim('Death2',, 0.1);
}

singular function Falling()
{
	SetPhysics(PHYS_Flying);
}

function PlayVictory()
{
	SetPhysics(PHYS_Falling);
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
    PlaySound(Victory,SLOT_Interact);	
	SetAnimAction('Eating');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');	
}

simulated function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying);
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
	if (Physics == PHYS_Flying)
		return Location + (CollisionHeight*0.9) * vect(0,0,-1.0);
	else
		return Location + (CollisionHeight*0.8) * vect(0,0,-1.0);
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;

	if ( (Controller.target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.5 + Controller.Target.CollisionRadius + CollisionRadius))
	{
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;
		Controller.Target.TakeDamage(hitdamage, self,HitLocation, pushdir, class'MeleeDamage');
		return true;
	}
	return false;
}
simulated function PlayMoving()
{
	if (Physics == PHYS_Walking)
		SetAnimAction('LandWalkLoop');
	else
		SetAnimAction('MoveLoop');
}

simulated function PlayWaiting()
{
	if (Physics == PHYS_Walking)
		SetAnimAction('LandWalkLoop');
	else
	{
		if (frand() < 0.5)
			SetAnimAction('Idle1');	
		else
			SetAnimAction('Idle2');	
	}
}

function RangedAttack(Actor A)
{

	if ( bShotAnim )
		return;

	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		PlaySound(Sound'Slap', SLOT_Interact);
		if (Physics == PHYS_Walking)
			SetAnimAction('WalkHit');
		else
			SetAnimAction('Hit');
		MeleeDamageTarget(150,(A.Location-Location));
	}
	else
	{
		if (Physics == PHYS_Walking)
			SetAnimAction('WalkAttack');
		else
			SetAnimAction('Attack');
		Shoot();
	}
		
	bShotAnim = true;
}

function Shoot()
{
	local vector FireStart,X,Y,Z;
    local Projectile   Proj;
    local float decision;
	
	 if (!FastTrace(Controller.Target.Location))
		return;
		
	decision = FRand();

    if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);
		FireStart = GetFireStart(X,Y,Z);
		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
			SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
			SavedFireProperties.MaxRange = MyAmmo.MaxRange;
			SavedFireProperties.bTossed = MyAmmo.bTossed;
			SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
			SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
			SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
			SavedFireProperties.bInitialized = true;
		}
    }
    if ( decision < 0.5 && (vsize(Controller.Target.Location - Location) < 5000))
	{
        Proj=Spawn(class'SeekerTractorBeam',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,100));
		if (Proj != None)
		{	
			SeekerTractorBeam(Proj).SpawningSeeker = self;
			PlaySound(Echo,SLOT_Interact);
		}

    }
    else
    {
        Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,100));
        PlaySound(FireSound,SLOT_Interact);
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    SetPhysics(PHYS_Falling);
	PrePivot.Z = -60 * DrawScale;
	AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
    LifeSpan = RagdollLifeSpan;
    Velocity=vect(0,0,800);


    GotoState('Dying');
	if ( FRand() < 0.5 )
		PlayAnim('Death1', 0.7, 0.1);
	else
	{
		PlayAnim('Death2', 0.7, 0.1);
	}
}

event Landed(vector HitNormal)
{
	super.Landed(HitNormal);
	
	if ( Health > 0 )
		SetPhysics(PHYS_Walking);
}

event HitWall( vector HitNormal, actor HitWall )
{
	if ( HitNormal.Z > MINFLOORZ )
		SetPhysics(PHYS_Walking);

	Super.HitWall(HitNormal,HitWall);
}

defaultproperties
{
     Echo=ProceduralSound'OutdoorAmbience.BThunder.P2creature1'
     Victory=ProceduralSound'OutdoorAmbience.BThunder.P1creature1'
     bMeleeFighter=False
     DodgeSkillAdjust=5.000000
     DeathSound(0)=ProceduralSound'OutdoorAmbience.BThunder.Pfrog1'
     DeathSound(1)=ProceduralSound'OutdoorAmbience.BThunder.Pfrog1'
     DeathSound(2)=ProceduralSound'OutdoorAmbience.BThunder.Pfrog1'
     DeathSound(3)=ProceduralSound'OutdoorAmbience.BThunder.Pfrog1'
     FireSound=SoundGroup'WeaponSounds.PulseRifle.PulseRifleFire'
     AmmunitionClass=Class'tk_Seeker.SeekerAmmo'
     ScoringValue=35
     IdleHeavyAnim="Idle2"
     IdleRifleAnim="Idle1"
     bCanCrouch=True
     bCanFly=True
     GroundSpeed=200.000000
     AirSpeed=575.000000
     Health=800
     bDoTorsoTwist=False
     MovementAnims(0)="LandWalkLoop"
     MovementAnims(1)="LandWalkLoop"
     MovementAnims(2)="LandWalkLoop"
     MovementAnims(3)="LandWalkLoop"
     TurnLeftAnim="Jump"
     TurnRightAnim="Jump"
     SwimAnims(0)="MoveLoop"
     SwimAnims(1)="MoveLoop"
     SwimAnims(2)="MoveLoop"
     SwimAnims(3)="MoveLoop"
     CrouchAnims(0)="Land"
     CrouchAnims(1)="Land"
     CrouchAnims(2)="Land"
     CrouchAnims(3)="Land"
     WalkAnims(0)="LandWalkLoop"
     WalkAnims(1)="LandWalkLoop"
     WalkAnims(2)="LandWalkLoop"
     WalkAnims(3)="LandWalkLoop"
     AirAnims(0)="MoveLoop"
     AirAnims(1)="MoveLoop"
     AirAnims(2)="MoveLoop"
     AirAnims(3)="MoveLoop"
     TakeoffAnims(0)="TakeOff"
     TakeoffAnims(1)="TakeOff"
     TakeoffAnims(2)="TakeOff"
     TakeoffAnims(3)="TakeOff"
     AirStillAnim="MoveLoop"
     TakeoffStillAnim="MoveLoop"
     CrouchTurnRightAnim="LandWalkLoop"
     CrouchTurnLeftAnim="LandWalkLoop"
     IdleCrouchAnim="Idle2"
     IdleSwimAnim="MoveLoop"
     IdleWeaponAnim="Idle2"
     IdleRestAnim="Idle1"
     IdleChatAnim="Idle1"
     RootBone="root"
     HeadBone="Eyeball"
     SpineBone1="BackBase"
     SpineBone2="BackMid"
     Mesh=SkeletalMesh'tk_Seeker.Seeker.Seeker'
     DrawScale=0.500000
     PrePivot=(Z=-7.500000)
     Skins(0)=FinalBlend'tk_Seeker.Seeker.BodyFinal'
     Skins(1)=FinalBlend'tk_Seeker.Seeker.EyeFinal'
     CollisionRadius=45.000000
     CollisionHeight=65.000000
     Mass=700.000000
}
