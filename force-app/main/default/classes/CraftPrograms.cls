public class CraftPrograms {
    
    public static String craftC(String strToEvaluate) {
        if(String.isBlank(strToEvaluate)){
            return null;
        }
        List<String> charArray = strToEvaluate.split('');
        Set<String> setOfUniqueChars = new Set<String>();
        String returnedString = '';
        for(String ch : charArray){
            setOfUniqueChars.add(ch);
        }
        if(setOfUniqueChars.size() == 1){
            return '0, all are repeated';
        }
        for(String ch : setOfUniqueChars) {
            returnedString = returnedString + ch;
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