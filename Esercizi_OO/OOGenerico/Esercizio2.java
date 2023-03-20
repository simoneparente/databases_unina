

class Simulator{
    Simulator s;
    int n;
    String stats;

    Simulator simulate(int e){
        s = getNumiteration();
    
        
        for(int i=0; i<n; i++){
            createCar(e);

            stats=getStats();
        
        }
    }

    Simulator getNumiteration(){
        //...
        return this;
    }

    void createCar(int e){
        //...
        int a=1;
    }

    String getStats(){
        //...
        return stats;
    }

    return this;
}

class Car{
    void rev(){
        //...
    }
}