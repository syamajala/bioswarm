public class Box {
    var v1:Array[Double];
    var v2:Array[Double];
    var v3:Array[Double];
    var v4:Array[Double];
    var h:Double;
    
    def this(l:Double, w:Double, h:Double, p:Array[Double]{self.size == 3}) {
        this.v1 = p;
        this.v2 = new Array[Double](3, (i:Int) => (i == 1) ? p(i)+w : p(i));
        this.v3 = new Array[Double](3);
        v3(0) = p(0)+l; v3(1) = p(1)+w; v3(2) = p(2);
        this.v4 = new Array[Double](3, (i:Int) => (i == 0) ? p(i)+l : p(i));       
        this.h = h;
    }

    def contained(x:Double, y:Double, z:Double):Boolean {
        if ((x >= this.v1(0) && x <= this.v4(0)) && 
            (y >= this.v1(1) && y <= this.v2(1)) &&
            (z >= 0 && z <= this.h))
            return true;

        return false;
    }

}