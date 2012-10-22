import x10.util.ArrayList;


public class PheromoneGroup extends EnvAffectorGroup {
    var strength:ArrayList[double];
    var decay_rate:double;
    var group_type:int;
    
    def this(group_type:int, decay_rate:double) {
        this.decay_rate = decay_rate;
        this.group_type = group_type;
    }
    
    public def stepDynamicAttributes():void {
        for (var p:int = 0; p < strength.size(); p++) {
            if (strength(p) > 1e-6) {
            	strength(p) /= this.decay_rate;
            } else {
                strength(p) = 0;
            }
        }
    }
}