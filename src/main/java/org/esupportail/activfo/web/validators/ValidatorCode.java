package org.esupportail.activfo.web.validators;

import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;

import org.esupportail.commons.beans.AbstractI18nAwareBean;

public class ValidatorCode extends AbstractI18nAwareBean implements Validator{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8849185735359561457L;

	/**
	 * 
	 */

	public void validate(FacesContext context, UIComponent componentToValidate,Object value) throws ValidatorException {
		if (value instanceof String) {
			String strValue = (String) value;
			
			if (!strValue.matches("^[0-9]{6}$")) {
				throw new ValidatorException(getFacesErrorMessage("VALIDATOR.CODE.INVALID"));
			}
		}
		else throw new ValidatorException(getFacesErrorMessage("VALIDATOR.NOTSTRING"));
	}
	
}