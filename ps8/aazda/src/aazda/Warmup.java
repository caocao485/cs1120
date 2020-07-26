package aazda;

import java.util.ArrayList;

public class Warmup {


    /**
     * @param args
     */
    public static void main(String[] args) {
        // TODO Auto-generated method stub
        System.out.println("Printing in Java is much harder than Scheme and Python!");
        for(int i=1;i<200;i++){
            System.out.println(fact(i));
        }
        ArrayList<String> stringArrayList = createArrayList();
        System.out.println(stringArrayList);
        reverseList(stringArrayList);
        System.out.println(stringArrayList);
    }
    public static int  fact(int n){
        if(n == 1){
            return n;
        }else{
            return n*fact(n-1);
        }
    }

    public static final ArrayList<String> createArrayList(){
        ArrayList<String> aList = new ArrayList<String>();
        aList.add("first");
        aList.add("second");
        aList.add("third");
        aList.add("fourth");
        System.out.println(aList.get(1));
        return aList;
    }

    public static final <E> void reverseList(ArrayList<E> arrayList){
        E pre;
        E next;
        int listSize = arrayList.size();
        if (listSize == 1){
            return;
        }else {
            for (int i = 0; i < listSize/2 ; i++) {
                pre = arrayList.get(i);
                next = arrayList.get(listSize - 1 -i);
                arrayList.set(i,next);
                arrayList.set(listSize-1-i,pre);
            }
        }

    }

}
