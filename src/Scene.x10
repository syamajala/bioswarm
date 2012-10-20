public class Scene {
	var actorGroups:Array[ActorGroup](1);
	//var propGroups:Array[EnvAffectorGroup](1);
	
	def stepScene():void {
		for (ag in actorGroups) {
			actorGroups(ag).updateScene();
		}
	}
	
}