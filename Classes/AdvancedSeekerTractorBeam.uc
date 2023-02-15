class AdvancedSeekerTractorBeam extends SeekerTractorBeam;

var bool bSetUpBeams;

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if ( Level.NetMode != NM_DedicatedServer)
	{
		if (!bSetUpBeams)
		{
			if (WaveEffect != None)
			{
				bSetUpBeams = true;
				// re-color the emitters
				SpriteEmitter(WaveEffect.Emitters[0]).ColorScale[0].Color.G=0;
				SpriteEmitter(WaveEffect.Emitters[0]).ColorScale[0].Color.R=255;
				SpriteEmitter(WaveEffect.Emitters[0]).ColorScale[1].RelativeTime=1.0;
				SpriteEmitter(WaveEffect.Emitters[0]).ColorScale[1].Color.B=64;
				SpriteEmitter(WaveEffect.Emitters[0]).ColorScale[1].Color.R=128;
				SpriteEmitter(WaveEffect.Emitters[0]).ColorScale[1].Color.G=0;
				
		
				BeamEmitter(TractorBeam.Emitters[0]).ColorScale[0].Color.R=255;
				BeamEmitter(TractorBeam.Emitters[0]).ColorScale[0].Color.G=0;
				BeamEmitter(TractorBeam.Emitters[0]).ColorScale[0].Color.B=0;
				BeamEmitter(TractorBeam.Emitters[0]).ColorScale[1].RelativeTime=1.0;
				BeamEmitter(TractorBeam.Emitters[0]).ColorScale[1].Color.R=128;
				BeamEmitter(TractorBeam.Emitters[0]).ColorScale[1].Color.G=0;
				BeamEmitter(TractorBeam.Emitters[0]).ColorScale[1].Color.B=64;			
			}
		}
	}
}

	

defaultproperties
{
     AccelFactor=3000
     TractorFactor=1200
     InfluenceRadius=500
     Speed=5000.000000
}
