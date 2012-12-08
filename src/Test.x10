import x10.util.ArrayList;
import x10.util.Pair;
import x10.util.Random;

public class Test {
   
    def distToActorTest() {
        var s:Scene = new Scene(new Random());
        s.actorGroups = new Array[ActorGroup](1);
        val pos = [2.0, 0.0, 0.0, 1.0, 0.0, 0.0];
        s.actorGroups(0) = new FireflyGroup(2, pos, 0, s);
        Console.OUT.println("testing distToActor");
        val r = s.distToActor(pos(0), pos(1), pos(2), 0, 1);
        assert (r == 1.0);
        Console.OUT.println("success!");
    }

    def distToAffectorTest() {
        var s:Scene = new Scene(new Random());
        val pos2 = [0.0, 2.0, 0.0];
        s.affectorGroups = new Array[EnvAffectorGroup](1);
        s.affectorGroups(0) = new FoodGroup(1, pos2);

        s.actorGroups = new Array[ActorGroup](1);
        val pos = [0.0, 1.0, 0.0];
        s.actorGroups(0) = new FireflyGroup(1, pos, 0, s);

        Console.OUT.println("testing distToAffector");
        val r = s.distToAffector(pos(0), pos(1), pos(2), 0, 0);
        assert (r == 1.0);
        Console.OUT.println("success!");
    }

    def serialactorQueryTest() {
        var s:Scene = new Scene(new Random());
        s.affectorGroups = new Array[EnvAffectorGroup](0);
        s.actorGroups = new Array[ActorGroup](1);

        val pos = [1.0, 1.0, 1.0, 2.0, 2.0, 2.0];
        var actors:FireflyGroup = new FireflyGroup(2, pos, 0, s);
        actors.actorFlashIntensity(0) = 2.0;
        actors.actorFlashIntensity(1) = 10.0;
        s.actorGroups(0) = actors;
        
        s.serialstepScene();
        val x = s.actorGroups(0).pos(0);
        val y = s.actorGroups(0).pos(1);
        val z = s.actorGroups(0).pos(2);
        val env = s.actorQuery(x, y, z, 50);

        val p = env(0);
        val g = p.first;
        val a = p.second;
        Console.OUT.println("testing actorQuery with serialstepScene");
        assert ((g == 0) && (a == 1));
        Console.OUT.println("success!");
    }

    def parallelactorQueryTest() {
        var s:Scene = new Scene(new Random());
        s.affectorGroups = new Array[EnvAffectorGroup](0);
        s.actorGroups = new Array[ActorGroup](1);

        val pos = [1.0, 1.0, 1.0, 2.0, 2.0, 2.0];
        var actors:FireflyGroup = new FireflyGroup(2, pos, 0, s);
        actors.actorFlashIntensity(0) = 2.0;
        actors.actorFlashIntensity(1) = 10.0;
        s.actorGroups(0) = actors;
        
        s.parallelstepScene(16);
        val x = s.actorGroups(0).pos(0);
        val y = s.actorGroups(0).pos(1);
        val z = s.actorGroups(0).pos(2);
        val env = s.actorQuery(x, y, z, 50);

        val p = env(0);
        val g = p.first;
        val a = p.second;
        Console.OUT.println("testing actorQuery with parallel");
        assert ((g == 0) && (a == 1));
        Console.OUT.println("success!");
    }


    def envQueryTest() {
        var s:Scene = new Scene(new Random());
        s.affectorGroups = new Array[EnvAffectorGroup](1);
        s.affectorGroups(0) = new HiveEntranceGroup(1, [0.0 as double, 0.0 as double, 0.0 as double]);

        s.actorGroups = new Array[ActorGroup](1);
        val pos = [1.0 as double, 1.0 as double, 0.0 as double];
        s.actorGroups(0) = new AntGroup(1, pos, s);
        
        Console.OUT.println("testing envAffectorQuery");
        val x = s.actorGroups(0).pos(0);
        val y = s.actorGroups(0).pos(1);
        val z = s.actorGroups(0).pos(2);
        val env = s.envAffectorQuery(x, y, z, 10);

        val p = env(0);
        val g = p.first;
        val e = p.second;

        assert ((g == 3) && (e == 0));
        
        Console.OUT.println("success!");
    }

    def serialParallelStepPositionEquivalenceTest() {
        var ps:Scene = new Scene(new Random(666));
        ps.affectorGroups = new Array[EnvAffectorGroup](1);
        ps.affectorGroups(0) = new HiveEntranceGroup(1, [0.0 as double, 0.0 as double, 0.0 as double]);

        ps.actorGroups = new Array[ActorGroup](1);
        ps.actorGroups(0) = new AntGroup(30, ps);

        ps.actorGroups(0).rand.init(666);
	
        ps.parallelstepScene(7);

        var ss:Scene = new Scene(new Random(666));
        ss.affectorGroups = new Array[EnvAffectorGroup](1);
        ss.affectorGroups(0) = new HiveEntranceGroup(1, [0.0 as double, 0.0 as double, 0.0 as double]);

        ss.actorGroups = new Array[ActorGroup](1);
        ss.actorGroups(0) = new AntGroup(30, ss);

        ss.actorGroups(0).rand.init(666);

        ss.serialstepScene();

        //ps.actorGroups(0).rand.init(666);
        //ss.actorGroups(0).rand.init(666);


        for (var i:int = 0; i < 30; i++) {
            //Console.OUT.println("ps random.nextDouble(): " + ps.actorGroups(0).rand.nextDouble());
            //Console.OUT.println("ss random.nextDouble(): " + ss.actorGroups(0).rand.nextDouble());
            Console.OUT.println("para pos: " + ps.actorGroups(0).pos(3*i));
            Console.OUT.println("serial pos: " + ss.actorGroups(0).pos(3*i));
            Console.OUT.println("T: " + (ps.actorGroups(0).pos(3*i) == ss.actorGroups(0).pos(3*i)));
        }

        //assert(ps.actorGroups(0).pos(0) == ss.actorGroups(0).pos(0));
    }

    public static def main(argv:Array[String]{self.rank==1}) {
        val test = new Test();
        test.distToActorTest();
        test.distToAffectorTest();
        test.serialactorQueryTest();
        test.parallelactorQueryTest();
        test.envQueryTest();
        test.serialParallelStepPositionEquivalenceTest();
    } 
}