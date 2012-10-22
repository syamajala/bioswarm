public class Test {
   
    def distTest1() {
        var s:Scene = new Scene();
        s.actorGroups = new Array[ActorGroup](1);
        val pos = new Array[Double](6);
        pos(0) = 2.0; pos(1) = 0.0; pos(2) = 0.0;
        pos(3) = 1.0; pos(4) = 0.0; pos(5) = 0.0;
        s.actorGroups(0) = new FireflyGroup(2, pos, s);
        Console.OUT.println("testing distToActor");
        val r = s.distToActor(pos(0), pos(1), pos(2), 0, 1);
        if (r != 1.0) 
            throw new Exception("Error!");
        Console.OUT.println("success!");
    }

    def distTest2() {
        var s:Scene = new Scene();
        val pos2 = new Array[Double](3);
        pos2(0) = 0.0; pos2(1) = 2.0; pos2(2) = 0.0;
        s.affectorGroups = new Array[EnvAffectorGroup](1);
        s.affectorGroups(0) = new FoodGroup(1, pos2);

        s.actorGroups = new Array[ActorGroup](1);
        val pos = new Array[Double](3);
        pos(0) = 0.0; pos(1) = 1.0; pos(2) = 0.0;
        s.actorGroups(0) = new FireflyGroup(1, pos, s);

        Console.OUT.println("testing distToAffector");
        val r = s.distToAffector(pos(0), pos(1), pos(2), 0, 0);
        if (r != 1.0) 
            throw new Exception("Error!");
        Console.OUT.println("success!");
    }

    public static def main(argv:Array[String]{self.rank==1}) {
        val test = new Test();
        test.distTest1();
        test.distTest2();
    } 
}