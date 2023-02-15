class AdvSeekerBioDecal extends xScorch;

simulated function BeginPlay()
{
	if ( !Level.bDropDetail && (FRand() < 0.5) )
		ProjTexture = Texture'tk_Seeker.Seeker.SeekerSplat2';
	Super.BeginPlay();
}

defaultproperties
{
     ProjTexture=Texture'tk_Seeker.Seeker.seekerSplat'
     CullDistance=7000.000000
     LifeSpan=6.000000
     DrawScale=0.850000
}
