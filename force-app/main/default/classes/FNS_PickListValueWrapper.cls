/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Community
    * @description Deserialize the picklist Value response to get the picklist values. 
  */
public with sharing class FNS_PickListValueWrapper {
  public ControllerValues controllerValues;
	public Object defaultValue;
	public String eTag;
	public String url;
	public List<Values> values;

	public with sharing class Attributes {
		public Boolean closed;
		public Integer defaultProbability;
		public String forecastCategoryName;
		public String picklistAtrributesValueType;
		public Boolean won;
	}

	public with sharing class Values {
		public Attributes attributes;
		public String label;
		public List<ControllerValues> validFor;
		public String value;
	}

	public with sharing class ControllerValues {
	}

	
	public static FNS_PickListValueWrapper parse(String json) {
		return (FNS_PickListValueWrapper) System.JSON.deserialize(json, FNS_PickListValueWrapper.class);
	}
}