<%@include file="_include.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<e:page stringsVar="msgs" menuItem="account" locale="#{sessionController.locale}">
<%@include file="_includeScript.jsp"%>
<div class="pc">

<script>
$(function() {
	<!-- Utiliser un tag jsf comme outputText-->
	<!-- Mettre cette partie de code après e:page, sinon outputText ne sera jamais evalué -->
	if(<t:outputText value="#{accountController.reinit}" />){progressBar(3);}
	if(<t:outputText value="#{accountController.activ || accountController.passwChange || accountController.loginChange}" />){progressBar(1);}
	
	
});
</script>



		<div class="container-fluid">
				<t:documentHead>
					<meta http-equiv="Expires" content="0">
					<meta http-equiv="cache-control" content="no-cache,no-store">
					<meta http-equiv="pragma" content="no-cache">
				</t:documentHead>
				<%@include file="_includeBreadcrumb.jsp"%>
				<%@include file="_includeProgessBar.jsp"%>
				<e:messages/>
				
				<e:paragraph value="#{msgs['PERSOINFO.TEXT.TOP']}" escape="false"/>
			
				<h:form id="accountForm" enctype="multipart/form-data">
				<t:dataList value="#{accountController.beanData}" var="category">
				  <h:dataTable  value="#{category.profilingListBeanField}" rendered="#{category.access}" var="beanfield" columnClasses="firstColumn,secondColumn,thirdColumn"> 
					<h:column >						
					  <t:outputText styleClass="labeltext" value="#{msgs[beanfield.key]}" />
					  <t:div styleClass="#{beanfield.name} photoBorderModify" rendered="#{beanfield.fieldType=='inputFileUpload'}" >
                           <h:graphicImage  value="../media/images/deletedPhoto.png" styleClass="showDeletePhoto" style="display:none;"></h:graphicImage>
                           <h:graphicImage url="data:image/jpg;base64,#{beanfield.value}" styleClass="photo photoSize export"></h:graphicImage>
                       </t:div>
                      <!-- Gestion affichage des bourons rotation et validation -->
                      <t:div rendered="#{beanfield.fieldType=='inputFileUpload'}">
                          <t:div styleClass="insertinnerHTMLRotation" style="margin-top:3em;"></t:div>
                      </t:div>
					</h:column>
					<h:column>
					 <t:div rendered="#{beanfield.fieldType=='inputFileUpload'}">
					   <t:div styleClass="alert alert-success" style="display:none;"><t:outputText  value="Votre photo est prise en compte"/></t:div>
					   <t:div styleClass="alert alert-danger" style="display:none;"><t:outputText  value="Votre photo pose problème, veuillez vérifier son format et/ou son contenu"/></t:div>
                       <t:inputFileUpload value="#{beanfield.fileUpLoad}" onchange="readFile(this)" styleClass="upload" storage="file" accept="image/jpeg" validator="#{beanfield.validator.validate}"></t:inputFileUpload>
					   <h:graphicImage  alt="#{beanfield.name}" styleClass="delete" value="../media/images/delete.png" style="float:right;margin-right: -30px;margin-top: -24.9px;" rendered="#{beanfield.fieldType=='inputFileUpload'&&beanfield.deleteJpegPhoto==1}" />
                       <h:inputText value="#{beanfield.deleteJpegPhoto}" styleClass="deletePhoto" style="display:none;" />
                       <!-- Alimenter dataURL du beanfield par la photo modiée via Croppie-->
                       <h:inputText value="#{beanfield.dataURL}"   styleClass="setDataURL" style="display:none;"/>
                    </t:div>
					<t:dataList value="#{beanfield.values}" var="sub">
						<t:div rendered="#{beanfield.hiddenField==''}">
							<t:div rendered="#{sub.value!=''&&!sub.convertedValue||(sub.value==''&&!beanfield.multiValue)}" styleClass="#{beanfield.name}show">
							    <h:inputText value="#{sub.value}"  disabled="#{beanfield.disable}" converter="#{beanfield.converter}" validator="#{beanfield.validator.validate}"  required="#{beanfield.required}" size="35" rendered="#{beanfield.fieldType=='inputText'&&beanfield.validator!=null&&(sub.value!=''||(sub.value==''&&!beanfield.multiValue))}" immediate="true" valueChangeListener="#{sub.setValue}"/>
					            <h:inputText value="#{sub.value}"  disabled="#{beanfield.disable}" converter="#{beanfield.converter}" required="#{beanfield.required}" size="35" rendered="#{beanfield.fieldType=='inputText'&&beanfield.validator==null&&(sub.value!=''&&!sub.convertedValue||(sub.value==''&&!beanfield.multiValue))}" immediate="true" valueChangeListener="#{sub.setValue}"/>
					            <h:selectOneMenu value="#{sub.value}" style="max-width:23em" rendered="#{beanfield.fieldType=='selectOneMenu'&&(sub.value!=''&&!sub.convertedValue||(sub.value==''&&!beanfield.multiValue))}" >
				                  <f:selectItems value="#{beanfield.displayItems}" />
								</h:selectOneMenu>
					        </t:div>
					        <t:div rendered="#{sub.value==''&&beanfield.multiValue}" style="display:none;" styleClass="#{beanfield.name}hide" >
					            <h:inputText value="#{sub.value}" size="35" rendered="#{beanfield.fieldType=='inputText'&&beanfield.validator!=null&&sub.value==''&&beanfield.multiValue}" immediate="true" valueChangeListener="#{sub.setValue}"/>
					            <h:inputText value="#{sub.value}" size="35" rendered="#{beanfield.fieldType=='inputText'&&beanfield.validator==null&&sub.value==''&&beanfield.multiValue}" immediate="true" valueChangeListener="#{sub.setValue}"/>
					            <h:selectOneMenu value="#{sub.value}" style="max-width:23em" rendered="#{beanfield.fieldType=='selectOneMenu'&&sub.value==''&&beanfield.multiValue}" >
				                  <f:selectItems value="#{beanfield.displayItems}" />
								</h:selectOneMenu>
				            </t:div>
				       </t:div>
				       <!-- Ajouter un input NON IMMEDIATE caché pour déclencher le validatorMailPersoOrMobilePhone dès la confirmatin du formaulaire, 
			            il peut être attaché à un checkox,car pas de immédiate, mais ce dernier ne se déclenche que lorsque le Checkbox est saisie (Bug jsf 1.2)-->
			            <t:div rendered="#{beanfield.hiddenField!=''&&beanfield.validator!=null}">
				            <h:inputText value="#{sub.value}" validator="#{beanfield.validator.validate}" style="#{beanfield.hiddenField}"/>
				        </t:div>
			        </t:dataList>
			        <!-- Avec validator -->
			        <t:div rendered="#{beanfield.fieldType=='selectManyCheckbox'}">             
							<h:selectManyCheckbox value="#{beanfield.selectedItems}" rendered="#{beanfield.fieldType=='selectManyCheckbox'&&beanfield.validator!=null}" validator="#{beanfield.validator.validate}" layout="pageDirection">
			                  <f:selectItems value="#{beanfield.displayItems}" />
			             	</h:selectManyCheckbox>        
			        </t:div>
			        <!-- Sans validator -->
					<t:div rendered="#{beanfield.fieldType=='selectManyCheckbox'}" >
						<h:selectManyCheckbox styleClass="showHideButton" value="#{beanfield.selectedItems}" rendered="#{beanfield.fieldType=='selectManyCheckbox'&&beanfield.validator==null}" layout="pageDirection">
							<f:selectItems value="#{beanfield.displayItems}" />
						</h:selectManyCheckbox>
					</t:div>
			        <t:div rendered="#{beanfield.fieldType=='selectOneRadio'}">        
			            	<h:selectOneRadio value="#{beanfield.value}">
			                  <f:selectItems value="#{beanfield.displayItems}" />
			        		</h:selectOneRadio>              
			         </t:div>   
			         <h:outputText styleClass="constraint" value="#{msgs[beanfield.constraint]}" rendered="#{beanfield.constraint!=null}"/> 
			         <t:div><h:outputText styleClass="digestConstraint" value="#{msgs[beanfield.digestConstraint]}" rendered="#{beanfield.digestConstraint!=null}"/> </t:div>
			        </h:column>
			        	<h:column>
							<h:graphicImage styleClass="toolTipShow" title="#{msgs[beanfield.notice]}" value="../media/images/redtriangular.jpg"  style="border: 0;" rendered="#{!beanfield.updateable&&!beanfield.disable&&!accountController.viewDataChange&&beanfield.hiddenField==''}"/>
							<h:graphicImage styleClass="toolTipShow" title="#{msgs[beanfield.help]}" value="../media/images/help.jpg"  style="border: 0;" rendered="#{beanfield.help!=null&&!accountController.viewDataChange&&beanfield.hiddenField==''}"/>
							<t:div >
								<h:graphicImage alt="#{beanfield.name}" styleClass="show" value="../media/images/add.png"  style="border: 0;" rendered="#{beanfield.multiValue&&beanfield.fieldType=='inputText'&&(!beanfield.disable&&beanfield.hiddenField=='')}"/>
								<h:graphicImage alt="#{beanfield.name}" styleClass="hide" value="../media/images/remove.png"  style="border: 0;" rendered="#{beanfield.multiValue&&beanfield.fieldType=='inputText'&&(!beanfield.disable&&beanfield.hiddenField=='')}"/>
							</t:div>
						</h:column>
				</h:dataTable>
				</t:dataList>										
				<e:commandButton value="#{msgs['_.BUTTON.CONFIRM']}" action="#{accountController.pushChangeInfoPersonal}"  id="application" style="display:none;"/>
				</h:form>
				<button  class="btn btn-primary" onclick="simulateLinkClick('accountForm:application');"><span class="glyphicon glyphicon-ok"></span><h:outputText value="#{msgs['_.BUTTON.CONFIRM']}" /></button>
				
				<h:form id="restart" style="display:none;">
					<e:commandButton id="restartButton" value="#{msgs['APPLICATION.BUTTON.RESTART']}"
						action="#{exceptionController.restart}" />
				</h:form>
		</div>	
</div>
</e:page>
<script src="../media/scripts/croppie.js"></script>
<script src="../media/scripts/exif.js"></script>
<link rel="stylesheet" href="../media/croppie.css" />
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />
<script src="../media/scripts/croppieForm.js"></script>

<script type="text/javascript">
croppie();
</script>