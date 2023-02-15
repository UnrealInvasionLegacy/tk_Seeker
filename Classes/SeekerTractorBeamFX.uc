class SeekerTractorBeamFX extends Emitter;

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter30
         BeamEndPoints(0)=(ActorTag="DummyTag")
         DetermineEndPointBy=PTEP_OffsetAsAbsolute
         LowFrequencyNoiseRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         HighFrequencyNoiseRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         UseBranching=True
         BranchProbability=(Max=1.000000)
         BranchSpawnAmountRange=(Min=2.000000,Max=3.000000)
         LinkupLifetime=True
         UseColorScale=True
         ColorScale(0)=(Color=(B=19,G=192,R=236))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=80,G=175,R=239))
         MaxParticles=1
         StartSizeRange=(X=(Min=50.000000,Max=75.000000),Y=(Min=50.000000,Max=75.000000))
         Texture=Texture'EpicParticles.Beams.HotBeam02aw'
         LifetimeRange=(Min=0.150000,Max=0.150000)
     End Object
     Emitters(0)=BeamEmitter'tk_Seeker.SeekerTractorBeamFX.BeamEmitter30'

     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
}
