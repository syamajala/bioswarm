import x10.io.Console;
import x10.io.File;
import x10.io.Printer;

public class BioSwarm {

    public static def main(argv:Array[String]{self.rank==1}) {
        Console.OUT.println("BIOSWARM SIMULATOR");
        
        val output_file:File = new File("output.bswarm");
        val p:Printer = output_file.printer();
        
        
        Console.OUT.println("Initializing scene...");
        var s:Scene = new Scene();
        s.loadScene();
        
        var start_frame:Int = s.start_frame;
        var end_frame:Int = s.end_frame;
        
        for (frame in start_frame..end_frame) {
            Console.OUT.println("frame: " + frame);
            
            //progress the simulation one timestep.
            s.stepScene();
            
            //save out scene representation at current frame to file.
            s.outputSimState(p);
        }
        
        p.flush();
        
        Console.OUT.println("Simulation Complete.");
    }
    
}

