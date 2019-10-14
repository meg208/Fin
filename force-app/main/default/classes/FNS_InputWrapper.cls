public with sharing class FNS_InputWrapper {
    public List<FilterParam> filterParams;
    
    public with sharing class FilterParam {
        public String fieldName;
        public String operator;
        public String fieldType;
        public String fieldApi;
        public String value;
        public String currencyIsoCode;
    }
}