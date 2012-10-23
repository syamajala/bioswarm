import x10.util.ArrayList;

public class HiveEntranceGroup extends EnvAffectorGroup {
    
    def this(n:Int, p:Array[double]) {
        this.size = n;
        this.pos = new ArrayList[double](3*size);
        for (var i:Int = 0; i < p.size; i++)
            this.pos.add(p(i));
        this.group_type = EnvAffectorType.antHiveEntrance;
    }
    
    public def stepDynamicAttributes():void {
    	// TODO: auto-generated method stub
    }


}