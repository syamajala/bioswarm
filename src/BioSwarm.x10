import x10.io.Console;
import x10.io.File;
import x10.io.Printer;
import x10.util.Timer;
public class BioSwarm {

    public static def main(argv:Array[String]{self.rank==1}) {
        Console.OUT.println("BIOSWARM SIMULATOR");
        if (argv.size != 2) {
            Console.OUT.println("Usage: BioSwarm <scene-number>");
            return;
        }
        val soutput_file = new File("serial_output.bswarm");
        val sp = soutput_file.printer();
        
        Console.OUT.println("Initializing scene...");

        val scene = Int.parseInt(argv(0));
        var s:Scene = new Scene();
        s.loadScene(scene);
        
        var start_frame:Int = s.start_frame;
        var end_frame:Int = s.end_frame;
        

        Console.OUT.println("Serial trial");
        val sstart = Timer.nanoTime();
        for (frame in start_frame..end_frame) {
            Console.OUT.println("FRAME " + frame);
            
            //progress the simulation one timestep.
            s.serialstepScene();
            
            //save out scene representation at current frame to file.
            s.outputSimState(sp);

        val sstop = Timer.nanoTime();
        val serialTime = (sstop-sstart)*Math.pow(10, -9);
        sp.flush();
        }
        val output_file = new File("output.bswarm");
        val p = output_file.printer();
        Console.OUT.println("Parallel trial");
        val pstart = Timer.nanoTime();
        for (frame in start_frame..end_frame) {
            Console.OUT.println("FRAME " + frame);
            s.parallelstepScene();
            s.outputSimState(p);
        }
        val pstop = Timer.nanoTime();
        val parallelTime = (pstop-pstart)*Math.pow(10, -9);
        Console.OUT.println("Simulation Complete.");
        Console.OUT.println("Serial time: " + serialTime);
        Console.OUT.println("Parallel time: " + parallelTime);
        Console.OUT.println("Speed up: " + serialTime/parallelTime);
    }
    
}

