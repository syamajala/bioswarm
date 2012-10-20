import x10.io.Console;

public class BioSwarm {

    public static def main(argv:Array[String]{self.rank==1}) {
        Console.OUT.println("BIOSWARM SIMULATOR");
        
        Console.OUT.println("Initializing scene...");
        var s:Scene = new Scene();
        s.loadScene();
        
        var start_frame:Int = s.start_frame;
        var end_frame:Int = s.end_frame;
        
        for (frame in start_frame..end_frame) {
            Console.OUT.println("frame: " + frame);
            s.stepScene();
        }
        
        Console.OUT.println("Simulation Complete.");
    }
    
}