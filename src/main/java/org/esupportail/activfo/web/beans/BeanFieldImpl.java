package org.esupportail.activfo.web.beans;

import java.util.ArrayList;
import java.util.List;

import javax.faces.convert.Converter;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;

import org.apache.myfaces.custom.fileupload.UploadedFile;
import org.esupportail.activfo.web.validators.Validator;
import org.esupportail.commons.services.logging.Logger;
import org.esupportail.commons.services.logging.LoggerImpl;


public class BeanFieldImpl<T> implements BeanField<T> {
	private final Logger logger = new LoggerImpl(getClass());
	
	private String key;
	private T value;
	private String fieldType=INPUTTEXT;
	private String help;
	private Converter converter;
	private Validator validator;
	private boolean required;
	private boolean disabled;
	private String id;
	
	private List<BeanMultiValue> values=new ArrayList<BeanMultiValue>();
	
	private List<String> selectedItems=new ArrayList<String>(); // les champs sélectionnés par l'utilisateur
	private List<SelectItem> displayItems=new ArrayList<SelectItem>(); // les champs à afficher à l'utilisateur
	private List<ProfileItem> displayProfileItems=new ArrayList<ProfileItem>();// variable globale contenant la liste des items du beanSMSAgreement
	private List<String> stringDisplayItems=new ArrayList<String>();
	
	private List<BeanMultiValue> hideItems=new ArrayList<BeanMultiValue>(); // valeurs recupérées du BO mais non exploitées par le FO. Lors de l'enregistrement, à renvoyer au BO
	
	private boolean multiValue;
	
	private String name;
	
	private int numberOfValue;
	
	private boolean disable;
	
	private boolean updateable;
	private boolean useDisplayItems; //si oui, ne considère que les valeurs présentes dans le champ displayItems. Sinon ne prend pas en compte displayItems
	private boolean useConvertedValue;
	
	private String notice;
	private String constraint;
	
	private String digestConstraint;
	
	private boolean sendMail;// envoyer un mail au gestionnaire lorsque un champ est udaptable sur LDAP
	
	private  UploadedFile fileUpLoad;
	private int deleteJpegPhoto=0; 
	private String hiddenField="";
	private String dataURL;
		
	public List<BeanMultiValue> getValues()	
	{  
		
	  if(MANYCHECKBOX.equals(fieldType))
		{
    	   values.clear();			
			for(String s : selectedItems){
				BeanMultiValue bmv = new BeanMultiValueImpl();				
				bmv.setConverter(converter);
				bmv.setUseConvertedValue(useConvertedValue);
				bmv.setValue(s);
				values.add(bmv);				
			}
			for(BeanMultiValue bmv: hideItems)
				this.values.add(bmv);								
		}
       
       if(ONERADIO.equals(fieldType)){
    	   values.clear();	
    	   BeanMultiValue bmv = new BeanMultiValueImpl();    	 
    	   bmv.setConverter(converter);
    	   bmv.setUseConvertedValue(useConvertedValue);
    	   bmv.setValue((String)value);
    	   values.add(bmv);				
       }
        
       if(INPUTFILE.equals(fieldType)){
          BeanMultiValue bmv = new BeanMultiValueImpl();
          if (deleteJpegPhoto!=2){
              if (dataURL!=null){
                if (dataURL.length()>0){
                    List<String> newValues=new ArrayList<String>();
                    newValues.add(getDataURL());
                    List<String> currentValues=new ArrayList<String>();
                    for (String retval: (" "+(String) value).split("encode64")) {
                      if (retval.length()>0){
                        currentValues.add((retval.trim()));
                      }
                    }

                    if(newValues.containsAll(currentValues)&&currentValues.containsAll(newValues)){
                       bmv.setValue(getDataURL());
                       values.add(bmv);
                    }
                    else{
                       bmv.setValue("encodeBase64"+getDataURL());
                       values.add(bmv);
                 }
               }
             }
          }
          else{
             values.clear();
             bmv.setValue(" ");
             values.add(bmv);
         }
       }
      
       if(!values.isEmpty()&& !INPUTFILE.equals(fieldType)){
   		value=(T)values.get(0).getValue();
		}
    
      
	   return this.values;
	}
	
	
	public void setValues(List<BeanMultiValue> values){
		
		this.values=values;
		selectedItems.clear();
		hideItems.clear();
		if(MANYCHECKBOX.equals(fieldType)){			
			if(useDisplayItems){
				initStringDisplayItems();
				for(BeanMultiValue bmv : values)
					if(stringDisplayItems.contains(bmv.getValue()))
						selectedItems.add(bmv.getValue());
					else 
						hideItems.add(bmv);
			}
			else for(BeanMultiValue bmv : values)				
					selectedItems.add(bmv.getValue());
		}
		for(BeanMultiValue bmv : values){ 
			bmv.setConverter(converter);
			bmv.setUseConvertedValue(useConvertedValue);
		}
	
		if(INPUTFILE.equals(fieldType)){
			dataURL="";
			if(!values.get(0).getValue().isEmpty())	{
				deleteJpegPhoto=1;}
			else {deleteJpegPhoto=0;}
				
			
		}
		
		if(!values.isEmpty()){
			value=(T)values.get(0).getValue();
		}
		
	}
	
	public UploadedFile getFileUpLoad() {
		return fileUpLoad;
	}

	public void setFileUpLoad(UploadedFile fileUpLoad) {
		this.fileUpLoad = fileUpLoad;
	}

	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
	public boolean isDisabled() {
		return disabled;
	}
	
	public void setDisabled(boolean disabled) {
		this.disabled = disabled;
	}
	
	public boolean isRequired() {
		return required;
	}
	public void setRequired(boolean required) {
		this.required = required;
	}
	
	public T getValue() {
		// L'attribut jsf graphicImage (dans accountDataChange.jsp) ne permet pas d'utiliser un convertisseur
		// il faut donc le forcer dans le code java
		if(this.isUseConvertedValue())
			return (T)converter.getAsString(null, null, value);
		else
			return value;
	}
	
	public void setValue(T value) {
		this.value = value;
	}
	
	public Validator getValidator() {
		return validator;
	}
	public void setValidator(Validator validator) {
		this.validator = validator;
	}
	
	public Converter getConverter() {
		return converter;
	}
	public void setConverter(Converter converter) {
		this.converter = converter;
	}
	public String getFieldType() {
		return fieldType;
	}
	public void setFieldType(String fieldType) {
		this.fieldType = fieldType;
	}
	public String getHelp() {
		return help;
	}
	public void setHelp(String help) {
		this.help = help;
	}
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getNumberOfValue() {
		return numberOfValue;
	}
	public void setNumberOfValue(int numberOfValue) {
		this.numberOfValue = numberOfValue;
	}
	/**
	 * @return the selectedItems
	 */
	public List<String> getSelectedItems() {		 
		return selectedItems;
	}
	/**
	 * @param selectedItems the selectedItems to set
	 */
	public void setSelectedItems(List<String> selectedItems) {		
        logger.debug("setSelectedItems (selectManyCheckbox) " + selectedItems);
		this.selectedItems = selectedItems;
	}
	/**
	 * @return the displayItems
	 */
	public List<SelectItem> getDisplayItems() {
		return this.displayItems;
	}
	
	private void initStringDisplayItems(){
		if(displayProfileItems.size()>0){
			for(ProfileItem si:displayProfileItems){
				if (si!=null && si.getValue()!=null && si.isAllowed())	 stringDisplayItems.add(String.valueOf(si.getValue()));
				
			}
			List<SelectItem> profileDisplayItems= new ArrayList<SelectItem>() ;
			
			for(ProfileItem si:displayProfileItems)
				if ( si!=null && si.getValue()!=null && si.isAllowed()){
					profileDisplayItems.add(si);
		}
			this.displayItems=profileDisplayItems;
		}
	}
	/**
	 * @param displayItems the displayItems to set
	 */
	public void setDisplayItems(List<SelectItem> displayItems) {
				
		for(SelectItem si:displayItems){
			 stringDisplayItems.add(String.valueOf(si.getValue()));
			 //i18n
		}
		this.displayItems = displayItems;
	}

	public void setDisplayProfileItems(List<ProfileItem> displayProfileItems) {
		/* Alimenter la variable globale this.displayProfileItems en effet
		 * setDisplayProfileItems est appelé une seule fois lors du lancement de l'application,les items sont perdus en mode connecté. Ces données stockées dans la variable globale
		 * seront utilisées dans initStringDisplayItems()
		 * 
		*/
		
		this.displayProfileItems = displayProfileItems;
		
		
	}
	/**
	 * @return the disable
	 */
	public boolean isDisable() {
		return disable;
	}
	/**
	 * @param disable the disable to set
	 */
	public void setDisable(boolean disable) {
		this.disable = disable;
	}
	

	 public void changeValue(ValueChangeEvent evt) {
       this.value= (T) evt.getNewValue();
	 }
	/**
	 * @return the key
	 */
	public String getKey() {
		return key;
	}
	/**
	 * @param key the key to set
	 */
	public void setKey(String key) {
		this.key = key;
	}

		/**
	 * @return the updateable
	 */
	public boolean isUpdateable() {
		return updateable;
	}

	/**
	 * @param updateable the updateable to set
	 */
	public void setUpdateable(boolean updateable) {
		this.updateable = updateable;
	}

	

	/**
	 * @return the notice
	 */
	public String getNotice() {
		return notice;
	}

	/**
	 * @param notice the notice to set
	 */
	public void setNotice(String notice) {
		this.notice = notice;
	}

	public int getSize() {
		if (values!=null)
			return values.size();
		else
			return 0;
	}

	/**
	 * @return the useDisplayItems
	 */
	public boolean isUseDisplayItems() {
		return useDisplayItems;
	}

	/**
	 * @param useDisplayItems the useDisplayItems to set
	 */
	public void setUseDisplayItems(boolean useDisplayItems) {
		this.useDisplayItems = useDisplayItems;
	}

	/**
	 * @return the useConvertedValue
	 */
	public boolean isUseConvertedValue() {
		return useConvertedValue;
	}

	/**
	 * @param useConvertedValue the useConvertedValue to set
	 */
	public void setUseConvertedValue(boolean useConvertedValue) {
		this.useConvertedValue = useConvertedValue;
	}

	/**
	 * @return the multiValue
	 */
	public boolean isMultiValue() {
		return multiValue;
	}

	/**
	 * @param multiValue the multiValue to set
	 */
	public void setMultiValue(boolean multiValue) {
		this.multiValue = multiValue;
	}

	/**
	 * @return the constraint
	 */
	public String getConstraint() {
		return constraint;
	}

	/**
	 * @param constraint the constraint to set
	 */
	public void setConstraint(String constraint) {
		this.constraint = constraint;
	}	
	public String getDigestConstraint() {
		return digestConstraint;
	}

	public void setDigestConstraint(String digestConstraint) {
		this.digestConstraint = digestConstraint;
	}

	public boolean isSendMail() {
		return sendMail;
	}

	public void setSendMail(boolean sendMail) {
		this.sendMail = sendMail;
	}

	public int getDeleteJpegPhoto() {
		return deleteJpegPhoto;
	}

	public void setDeleteJpegPhoto(int deleteJpegPhoto) {
		this.deleteJpegPhoto = deleteJpegPhoto;
	}

	public String getHiddenField() {
		return hiddenField;
	}

	public void setHiddenField(String hiddenField) {
		this.hiddenField = hiddenField;
	}

	public String getDataURL() {
		return dataURL;
	}

	public void setDataURL(String dataURL) {
		this.dataURL = dataURL;
	}
	
}
