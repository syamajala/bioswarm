public abstract class ActorGroup {
    var actorid:Array[Int](1);
    var actorPos:Array[Int](1);
    var actorHealth:Array[Int](1);

    static val x = 100;
    static val y = 100;

    abstract def updateScene():void;
}
