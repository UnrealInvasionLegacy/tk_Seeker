class SeekerTractorBeamEmitter extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         UniformSize=True
         ColorScale(0)=(Color=(G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255))
         FadeOutStartTime=0.250000
         FadeInEndTime=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=7
         Texture=Texture'EmitterTextures.Flares.EFlareB'
         LifetimeRange=(Min=2.000000,Max=2.000000)
     End Object
     Emitters(0)=SpriteEmitter'tk_Seeker.SeekerTractorBeamEmitter.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
}
