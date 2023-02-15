class AdvancedSeekerProjectile extends SeekerProjectile;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
    if ( Level.NetMode != NM_DedicatedServer)
	{
		if (Trail != None)
		{
		// ok.. so ColorMultiplierRange values... X is really R, Y is really G, and Z is B ... oops I think someone used the 
		// wrong struct at epic? Anyway, they are values from 0 to 1 indicating what fraction color should be used, a range 
		// provides for variable colors
		
		SpriteEmitter(Trail.Emitters[0]).ColorMultiplierRange.X.Min=1;
		SpriteEmitter(Trail.Emitters[0]).ColorMultiplierRange.X.Max=1;
		SpriteEmitter(Trail.Emitters[0]).ColorMultiplierRange.Y.Min=0.0;
		SpriteEmitter(Trail.Emitters[0]).ColorMultiplierRange.Y.Min=0.0;
		SpriteEmitter(Trail.Emitters[0]).ColorMultiplierRange.Z.Max=0.0;
		SpriteEmitter(Trail.Emitters[0]).ColorMultiplierRange.Z.Min=0.00;
		
		SpriteEmitter(Trail.Emitters[1]).ColorScale[1].Color.G=0;
		SpriteEmitter(Trail.Emitters[1]).ColorScale[1].Color.R=255;
		SpriteEmitter(Trail.Emitters[1]).ColorScale[1].RelativeTime=0.1;
		
		SpriteEmitter(Trail.Emitters[1]).ColorScale[2].Color.B=64;
		SpriteEmitter(Trail.Emitters[1]).ColorScale[2].Color.R=128;
		SpriteEmitter(Trail.Emitters[1]).ColorScale[2].Color.G=0;	
		SpriteEmitter(Trail.Emitters[1]).ColorScale[2].RelativeTime=0.8;
		
		SpriteEmitter(Trail.Emitters[1]).ColorScale[3].RelativeTime=1.0;
			

		SparkleTrail.mColorRange[0].G=0;
		SparkleTrail.mColorRange[0].R=128;	
		SparkleTrail.mColorRange[1].G=0;
		SparkleTrail.mColorRange[1].R=128;	
		}
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local AdvancedSeekerBioGlob NewGlob;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		for (i=0; i<15; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			NewGlob = Spawn( class 'AdvancedSeekerBioGlob',, '', Start, rot);
		}
	}
    if ( EffectIsRelevant(Location,false) )
        Spawn(class'AdvSeekerGoopSparks',,, HitLocation, rotator(HitNormal));

		PlaySound(Sound'WeaponSounds.BioRifle.BioRifleGoo2');

	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     Speed=6000.000000
     MaxSpeed=6000.000000
     Damage=1100.000000
     MyDamageType=Class'tk_Seeker.DamTypeAdvSeekerGoo'
     LightHue=253
     LightSaturation=127
     LightBrightness=201.000000
     Skins(0)=FinalBlend'tk_Seeker.Seeker.AdvProjectileSkin'
}
