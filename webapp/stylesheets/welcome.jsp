<%@include file="_include.jsp"%>
<e:page stringsVar="msgs" menuItem="welcome" locale="#{sessionController.locale}" >
	<%@include file="_navigation.jsp"%>
	<e:section value="#{msgs['WELCOME.TITLE']}" />
	
	<e:messages/>
	
	<h:panelGroup rendered="#{sessionController.currentUser != null}">
		<e:paragraph value="#{msgs['WELCOME.TEXT.AUTHENTICATED']}" />
	</h:panelGroup>
	
	<h:form id="welcomeForm" rendered="#{sessionController.currentUser == null}">
	
		<e:paragraph escape="false" value="#{msgs['WELCOME.STATUS.TEXT.TOP']}" />
		<t:selectOneRadio layout="pageDirection" required="true" value="#{accountController.currentAccount.oneRadioValue}">
	 		<t:selectItems value="#{accountController.listBeanStatus}" var="entry" itemLabel="#{msgs[entry.key]}" itemValue="#{entry.value}"></t:selectItems>
		</t:selectOneRadio>	
		
		<e:paragraph escape="false" value="#{msgs['WELCOME.PROCEDURE.TEXT.TOP']}" />
		<t:selectOneRadio layout="pageDirection" required="true" value="#{accountController.currentAccount.oneRadioProcedure}">
	 		<t:selectItems value="#{accountController.listBeanProcedure}" var="entry" itemLabel="#{msgs[entry.key]}" itemValue="#{entry.value}"></t:selectItems>
		</t:selectOneRadio>	
		
		<e:commandButton id="application" value="#{msgs['_.BUTTON.CONFIRM']}" action="#{accountController.enter}"/>
	
	</h:form>
	
<% /* @include file="_debug.jsp" */ %>
</e:page>
