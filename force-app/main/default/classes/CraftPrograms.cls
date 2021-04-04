public class CraftPrograms {
    
    public static String craftC(String strToEvaluate) {
        if(String.isBlank(strToEvaluate)){
            return null;
        }
        List<String> charArray = strToEvaluate.split('');
        Map<String,Integer> storedMap = new Map<String,Integer>();
        String returnedString = '';
        for(String stoCheck : charArray){
            if(storedMap.containsKey(stoCheck)){
                storedMap.put(stoCheck,storedMap.get(stoCheck)+1);
            }
            else {
                storedMap.put(stoCheck,1);
            }
        }
        if(storedMap.keySet().size() ==1){
            return '0, all are repeated';
        }
        for(String sMapvalue : storedMap.keySet()) {
            returnedString = returnedString + sMapvalue;
        } 
        return returnedString + ' - ' + returnedString.length();
    }
    
    public static Set<String> craftD(List<Integer> arrayOfIntegers) {
        Set<String> st = new Set<String>();
        for (Integer i = 0; i<arrayOfIntegers.size();i++){
            for(Integer j = i+1;j<arrayOfIntegers.size();j++){
                if(arrayOfIntegers[i] > arrayOfIntegers[j]){
                 st.add(arrayOfIntegers[i] + ';' + arrayOfIntegers[j]);
                }
            }
        }
        return st;
    }
}