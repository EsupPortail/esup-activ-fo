package org.esupportail.activfo.services.client;

import java.util.List;
import java.util.Map;

import org.esupportail.activfo.exceptions.AuthentificationException;
import org.esupportail.activfo.exceptions.ChannelException;
import org.esupportail.activfo.exceptions.KerberosException;
import org.esupportail.activfo.exceptions.LdapProblemException;
import org.esupportail.activfo.exceptions.LoginAlreadyExistsException;
import org.esupportail.activfo.exceptions.LoginException;
import org.esupportail.activfo.exceptions.PrincipalNotExistsException;
import org.esupportail.activfo.exceptions.UserPermissionException;


public interface AccountManagement {
	
	public Map<String, String> validateAccount(Map<String,String> hashInfToValidate,List<String>attrPersoInfo) throws LdapProblemException,AuthentificationException, LoginException;

	public void setPassword(String id,String code,final String currentPassword)throws LdapProblemException,UserPermissionException,KerberosException, LoginException;
	
	public void setPassword(String id,String code,String newLogin, final String currentPassword) throws LdapProblemException,UserPermissionException,KerberosException, LoginException;
		
	public void updatePersonalInformations(String id,String code,Map<String,String> hashBeanPersoInfo)throws LdapProblemException,UserPermissionException, LoginException;
	
	public void sendCode(String id,String canal)throws ChannelException;
		
	public boolean validateCode(String id,String code)throws UserPermissionException;
	
	public void changeLogin(String id, String code,String newLogin)throws LdapProblemException,UserPermissionException,KerberosException,LoginAlreadyExistsException, LoginException,PrincipalNotExistsException;
	
	public Map<String,String> authentificateUser(String id,String password,List<String>attrPersoInfo)throws AuthentificationException,LdapProblemException,UserPermissionException, LoginException;

	public String validatePassword(String id, String password) throws  KerberosException,LdapProblemException, LoginException;
}
