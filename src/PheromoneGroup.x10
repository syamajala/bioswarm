import x10.util.ArrayList;


public class PheromoneGroup extends EnvAffectorGroup {
    var strength:ArrayList[double];
    var decay_rate:double;
    var group_type:int;
    
    def this(group_type:int, decay_rate:double) {
        this.strength = new ArrayList[double]();
        this.pos = new ArrayList[double]();
        this.decay_rate = decay_rate;
        this.group_type = group_type;
        this.size = 0;
    }
    
    public def stepDynamicAttributes():void {
        for (var p:int = 0; p < strength.size(); p++) {
            if (strength(p) > 1.0) {
            	strength(p) /= this.decay_rate;
            } else { //decayed and gone, take out of env affector group.
                strength.removeAt(p);
                this.pos.removeAt(3*p);
                this.pos.removeAt(3*p+1);
                this.pos.removeAt(3*p+2);
                this.size--;
            }
        }
    }
}