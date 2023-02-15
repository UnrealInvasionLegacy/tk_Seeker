class M_AdvancedSeeker extends M_Seeker;

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
        Proj=Spawn(class'AdvancedSeekerTractorBeam',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,100));
		if (Proj != None)
		{	
			AdvancedSeekerTractorBeam(Proj).SpawningSeeker = self;
			PlaySound(Echo,SLOT_Interact);
		}
    }
    else
    {
        Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,100));
        PlaySound(FireSound,SLOT_Interact);
	}
}

defaultproperties
{
     AmmunitionClass=Class'tk_Seeker.AdvancedSeekerAmmo'
     ScoringValue=50
     AirSpeed=800.000000
     Health=1200
     DrawScale=0.750000
     PrePivot=(Z=-8.750000)
     Skins(0)=FinalBlend'tk_Seeker.Seeker.Body2Final'
     Skins(1)=FinalBlend'tk_Seeker.Seeker.Eye2Final'
     CollisionRadius=65.000000
     CollisionHeight=95.000000
     Mass=950.000000
}
