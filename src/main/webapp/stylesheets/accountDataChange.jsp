<%@include file="_include.jsp"%>
<e:page stringsVar="msgs" menuItem="account" locale="#{sessionController.locale}">
<%@include file="_includeScript.jsp"%>
<script type="text/javascript" src="../media/scripts/accountDataTabs.js"></script>

<script>
$(function() {
	// Afficher par défaut l'onglet modifier les données du menu du haut
	$('.nav-pills li:eq(0) a').tab('show');
	
	// Sauvegarder l'onglet seléctionné dans sessionStorage
    $(".nav-stacked").click(function (e) {
        var idSelected = $(e.target).attr("href").substr(1);
        sessionStorage.setItem("tabSelected",idSelected)
    });
	
});
</script>

<div class="pc">
<div class="container-fluid">
	<%@include file="_includeBreadcrumb.jsp"%>
	<h:form id="accountForm" enctype="multipart/form-data">
	<div class="mainBlock">
		<%@include file="_includeAccountData.jsp"%>	
			<div class="col-md-9">
				<div class="tab-content">
					<!-- Afficher message d'erreur -->
					 <e:messages />
					 
			   		<!-- Appeler la méthode getBeanData qui récupère les données, pour afficher la civilité et le displayName
					car avant cette méthode, aucune données n'est récupérées					 -->				
	   				<t:outputText value="#{accountController.beanData}" style="display:none"></t:outputText>
	   				
					<t:dataList value="#{accountController.beanData}"  var="category" >
						<t:div styleClass="hrefIdDetail mainModifyLinkByCategory tab-pane" rendered="#{category.access}">
								<t:htmlTag value="table">
								
									<t:htmlTag value="tr" styleClass="page-header">
										<t:htmlTag value="td">
											<t:div><e:paragraph value="#{accountController.currentAccount.supannCivilite} #{accountController.currentAccount.displayName}"  /></t:div>
										</t:htmlTag>
									</t:htmlTag>
									
									<t:htmlTag value="tr">
										<t:htmlTag value="td">
											<t:div style="margin-top:1em;"></t:div>
											<h:dataTable value="#{category.profilingListBeanField}"	rendered="#{category.access}" var="beanfield" columnClasses="firstColumn,secondColumn,thirdColumn,fourthColumn">
												<h:column>
													<t:outputText styleClass="#{beanfield.name} labeltexttop#{beanfield.size>1}"	value="#{msgs[beanfield.key]}"	rendered="#{beanfield.fieldType!='inputFileUpload'}" />
													<t:div styleClass="#{beanfield.name}output photoBorder" rendered="#{beanfield.fieldType=='inputFileUpload'}" >
														<!-- Ajout class  photoToCrop et export pour utiliser croppie-->
														<h:graphicImage url="data:image/jpg;base64,#{beanfield.value}" styleClass="photo" style="display:none;"></h:graphicImage>
														<!-- Export sert également de champ cliquable car croopie desactive  styleClass="photo"-->
														<h:graphicImage url="data:image/jpg;base64,#{beanfield.value}" styleClass="export photoSize"></h:graphicImage>
													</t:div>
													<t:div rendered="#{beanfield.fieldType=='inputFileUpload'}" >
                                                        <h:graphicImage  value="../media/images/deletedPhoto.png" styleClass="showDeletePhoto" style="display:none;"></h:graphicImage>
                                                    </t:div>
													<!-- Gestion affichage des bourons rotation et validation -->
													<t:div styleClass="#{beanfield.name}show" style="display:none;" rendered="#{beanfield.fieldType=='inputFileUpload'}">
														<t:div styleClass="insertinnerHTMLRotation" style="margin-top:3em;"></t:div>
													</t:div>
												</h:column>
												<h:column>
													<t:dataList value="#{beanfield.values}" var="sub" >
														<!----------------- En affichage -->
														<t:div styleClass="#{beanfield.name}output" rendered="#{!beanfield.disable&&beanfield.fieldType!='selectManyCheckbox'&&beanfield.fieldType!='selectOneRadio'&&beanfield.fieldType!='inputFileUpload'&&!sub.convertedValue}">
															<h:outputText value="#{sub.value}" rendered="#{beanfield.fieldType!='selectManyCheckbox'&&beanfield.fieldType!='selectOneRadio'&&beanfield.fieldType!='inputFileUpload'}" converter="#{beanfield.converter}"/>
														</t:div>
														<!--griser les champs non modifable  -->
														<t:div styleClass="text-muted" rendered="#{beanfield.disable&&beanfield.fieldType!='selectManyCheckbox'&&beanfield.fieldType!='selectOneRadio'&&beanfield.fieldType!='inputFileUpload'&&!sub.convertedValue}">
															<h:outputText value="#{sub.value}" rendered="#{beanfield.fieldType!='selectManyCheckbox'&&beanfield.fieldType!='selectOneRadio'&&beanfield.fieldType!='inputFileUpload'}" converter="#{beanfield.converter}"/>
														</t:div>
														
														<!-- ---------------En modification -->
														<!--* Champs avec valeur non vide -->       	    
														<t:div rendered="#{sub.value!=''&&!sub.convertedValue||(sub.value==''&&!beanfield.multiValue)}" style="display:none;" styleClass="#{beanfield.name}show">
														   <!-- Avec validator -->
														    <h:inputText value="#{sub.value}" styleClass="#{beanfield.name}Popup" disabled="#{beanfield.disable}" converter="#{beanfield.converter}" required="#{beanfield.required}" size="35" validator="#{beanfield.validator.validate}"  
														    	rendered="#{beanfield.fieldType=='inputText'&&beanfield.validator!=null&&(sub.value!=''||(sub.value==''&&!beanfield.multiValue))}" immediate="true" valueChangeListener="#{sub.setValue}"/>
												            <!-- Sans validator -->
												            <h:inputText value="#{sub.value}" styleClass="#{beanfield.name}Popup" disabled="#{beanfield.disable}" converter="#{beanfield.converter}" required="#{beanfield.required}" size="35" 
												            	rendered="#{beanfield.fieldType=='inputText'&&beanfield.validator==null&&(sub.value!=''&&!sub.convertedValue||(sub.value==''&&!beanfield.multiValue))}" immediate="true" valueChangeListener="#{sub.setValue}"/>
												            <!--Liste déroulante  -->
												            <h:selectOneMenu value="#{sub.value}" styleClass="#{beanfield.name}Popup" style="max-width:23em" rendered="#{beanfield.fieldType=='selectOneMenu'&&(sub.value!=''&&!sub.convertedValue||(sub.value==''&&!beanfield.multiValue))}" >
											                  <f:selectItems value="#{beanfield.displayItems}" />
											             	</h:selectOneMenu>               	             	             	  
												        </t:div>    	    
															       	    
															       	    
													    <!--* Champs avec valeur vide -->		       	        
														<t:div rendered="#{sub.value==''&&beanfield.multiValue}" style="display:none;" styleClass="#{beanfield.name}hideField" >  
															<h:inputText value="#{sub.value}" styleClass="#{beanfield.name}Popup" size="35" converter="#{beanfield.converter}" validator="#{beanfield.validator.validate}"  rendered="#{beanfield.fieldType=='inputText'&&beanfield.validator!=null&&sub.value==''&&beanfield.multiValue}" immediate="true" valueChangeListener="#{sub.setValue}"/>
															 <h:inputText value="#{sub.value}" styleClass="#{beanfield.name}Popup" size="35" rendered="#{beanfield.fieldType=='inputText'&&beanfield.validator==null&&sub.value==''&&beanfield.multiValue}" immediate="true" valueChangeListener="#{sub.setValue}"/>
															
															 <h:selectOneMenu value="#{sub.value}" styleClass="#{beanfield.name}Popup" style="max-width:23em" rendered="#{beanfield.fieldType=='selectOneMenu'&&sub.value==''&&beanfield.multiValue}" >
														     	 <f:selectItems value="#{beanfield.displayItems}" />
														 	  </h:selectOneMenu> 	            
														</t:div>          
													</t:dataList>
													<!-- Modifier la photo -->
													<t:div rendered="#{beanfield.fieldType=='inputFileUpload'}"	style="display:none;" styleClass="#{beanfield.name}show" >
													    <t:div styleClass="alert alert-danger" style="display:none;"><t:outputText  value="Votre photo pose problème, veuillez vérifier son format et/ou son contenu"/></t:div>
														<t:inputFileUpload value="#{beanfield.fileUpLoad}" onchange="readFile(this)" styleClass="upload" storage="file" accept="image/jpeg" validator="#{beanfield.validator.validate}"></t:inputFileUpload>
														<h:graphicImage alt="#{beanfield.name}" styleClass="delete"	value="../media/images/delete.png" style="float:right;margin-right: -30px;margin-top: -24.9px;"	rendered="#{beanfield.fieldType=='inputFileUpload'&&beanfield.deleteJpegPhoto==1}" />
														<h:inputText value="#{beanfield.deleteJpegPhoto}" styleClass="deletePhoto" style="display:none;" />
														<!-- Alimenter dataURL du beanfield par la photo modiée via Croppie-->
														<h:inputText value="#{beanfield.dataURL}"   styleClass="setDataURL" style="display:none;"/>
													</t:div>
													
													<!--Afficher la données sous forme de checkbox  -->
													<!-- Avec validator -->
													<t:div rendered="#{beanfield.fieldType=='selectManyCheckbox'}" >
														<h:selectManyCheckbox styleClass="showHideButton" value="#{beanfield.selectedItems}" rendered="#{beanfield.fieldType=='selectManyCheckbox'&&beanfield.validator!=null}" validator="#{beanfield.validator.validate}" layout="pageDirection">
															<f:selectItems value="#{beanfield.displayItems}" />
														</h:selectManyCheckbox>
													</t:div>
													<!-- Sans validator -->
													<t:div rendered="#{beanfield.fieldType=='selectManyCheckbox'}" >
														<h:selectManyCheckbox styleClass="showHideButton" value="#{beanfield.selectedItems}" rendered="#{beanfield.fieldType=='selectManyCheckbox'&&beanfield.validator==null}" layout="pageDirection">
															<f:selectItems value="#{beanfield.displayItems}" />
														</h:selectManyCheckbox>
													</t:div>
													<!--Afficher la données sous forme de radio bouton  -->
													<t:div rendered="#{beanfield.fieldType=='selectOneRadio'}"  >
														<h:selectOneRadio  styleClass="showHideButton" value="#{beanfield.value}" rendered="#{beanfield.fieldType=='selectOneRadio'}">
															<f:selectItems value="#{beanfield.displayItems}" />
														</h:selectOneRadio>
													</t:div>
													
													
													<!--Afficher les messages de contrainte ( en gris)  -->
													<h:outputText style="display:none" styleClass="#{beanfield.name}constraint constraint" value="#{msgs[beanfield.constraint]}" rendered="#{beanfield.constraint!=null}" />
													<h:outputText styleClass="constraint" value="#{msgs[beanfield.constraint]}" rendered="#{beanfield.constraint!=null&&(beanfield.fieldType=='selectOneRadio'||beanfield.fieldType=='selectManyCheckbox')}" />
													<!--Afficher les messages de digestConstraint  -->
													<t:div>
													 	<h:outputText style="display:none" styleClass="#{beanfield.name}digestConstraint digestConstraint" value="#{msgs[beanfield.digestConstraint]}" rendered="#{beanfield.digestConstraint!=null}" />
													 	<h:outputText styleClass="digestConstraint" value="#{msgs[beanfield.digestConstraint]}" rendered="#{beanfield.digestConstraint!=null&&(beanfield.fieldType=='selectOneRadio'||beanfield.fieldType=='selectManyCheckbox')}" />
													</t:div> 
			     										
												</h:column>
												<!--Afficher les boutons ajouter, supprimer et l'aide  -->
												<h:column>
														<h:graphicImage styleClass="toolTipShow"  title="#{msgs[beanfield.help]}"	value="../media/images/help.jpg" style="border: 0;" rendered="#{beanfield.help!=null&&!accountController.viewDataChange}" />
														<t:div style="display:none" styleClass="#{beanfield.name}modify">
															<h:graphicImage title="#{msgs[beanfield.notice]}" styleClass="#{beanfield.name}toValidateDRH toolTipShow" value="../media/images/redtriangular.jpg" style="border: 0" rendered="#{!beanfield.updateable&&!beanfield.disable&&!accountController.viewDataChange}" />
															<h:graphicImage alt="#{beanfield.name}" styleClass="showField" value="../media/images/add.png" style="border: 0;cursor:pointer" rendered="#{beanfield.multiValue&&!beanfield.disable&&(beanfield.fieldType=='inputText'||beanfield.fieldType=='selectOneMenu')}" />
															<h:graphicImage alt="#{beanfield.name}" styleClass="hideField" value="../media/images/remove.png" style="border: 0;cursor:pointer"	rendered="#{beanfield.multiValue&&!beanfield.disable&&(beanfield.fieldType=='inputText'||beanfield.fieldType=='selectOneMenu')}" />
														</t:div>
												</h:column>
												<!--Le styleClass="#{beanfield.name}_modifyLink" est un genre de tag qui permet de gérer l'affichage des champs en modification (voir form-show-hide.js)-->
												<h:column>
													<h:outputText styleClass="#{beanfield.name}_modifyLink" rendered="#{!beanfield.disable&&beanfield.fieldType!='selectManyCheckbox'&&beanfield.fieldType!='selectOneRadio'}"/>
													<!--Traitement pour les onglets ne contenant que des cases à cocher et ou radio buton à modifier, seul le bouton editer passe à confirmer)-->
													<h:outputText styleClass="#{beanfield.name}_modifyLinkCkeckRadio" rendered="#{!beanfield.disable&&beanfield.fieldType=='selectManyCheckbox'||beanfield.fieldType=='selectOneRadio'}"/>
										
												</h:column>
												
										</h:dataTable>
										
										<t:div style="margin-top:1em;">
											<!--Impossibilité d'utiliser le tag t:htmlTag de type bouton, car cela génère un bug (lié à esup-communs...)sur la boite de dialogue de type modal(la boite de dialogue apparait et disparait de suite) 
											-->
											<t:htmlTag style="display:none" rendered="#{category.access}" styleClass="validate btn btn-primary" value="a">
											    <f:param name="href" value="#" /><t:htmlTag  value="span" styleClass="glyphicon glyphicon-ok"></t:htmlTag>
											   <h:outputText value="#{msgs['_.BUTTON.CONFIRM']}" />
											</t:htmlTag>
											<t:htmlTag rendered="#{category.access}" styleClass="modifyByCategory btn btn-primary" value="a">
											   <f:param name="href" value="#" /> <t:htmlTag  value="span" styleClass="glyphicon glyphicon-edit"></t:htmlTag>
											   <h:outputText value="Editer mes données" />
											</t:htmlTag>
										</t:div>
										
									</t:htmlTag><!-- Fin htmlTag value="td" -->
								</t:htmlTag><!-- Fin htmlTag value="tr" -->
							</t:htmlTag>
						</t:div>	
					</t:dataList>		
			    </div><!-- tab content -->			    
			    </div><!-- Fin col-md-6 -->	
			    <!-- 			    
			    <div class="col-md-3">
			    	<div class="helppanel">		    			
	  					<div><h:outputText value="#{msgs['DATACHANGE.TEXT.LEGEND']}" /></div>							
						<div><img src="../media/images/help.jpg"><h:outputText styleClass="text-muted" value=": #{msgs['DATACHANGE.TEXT.LEGEND.HELP']}" /></div>
						<div><img src="../media/images/redtriangular.jpg"><h:outputText styleClass="text-muted" value=": #{msgs['DATACHANGE.TEXT.LEGEND.NOTE']}" /></div>
						<div><img src="../media/images/add.png"><h:outputText styleClass="text-muted" value=": #{msgs['DATACHANGE.TEXT.LEGEND.ADD']}" /></div>
						<div><img src="../media/images/remove.png"><h:outputText styleClass="text-muted" value=": #{msgs['DATACHANGE.TEXT.LEGEND.REMOVE']}" /></div>		    			
					</div>
			   </div> -->	
			   			
		</div><!--Fin row de  _includeAccountData.jsp -->
	
		
		<t:div style="display:none">
			<e:commandButton id="toDataView" value="#{msgs['_.BUTTON.CONFIRM']}" action="#{accountController.pushChangeInfoPersoDataView}"/>
			<e:commandButton id="saveDataChange" value="#{msgs['_.BUTTON.CONFIRM']}" action="#{accountController.pushChangeInfoPerso}" />
		</t:div>
	</div><!--Fin class="mainBlock"-->
</h:form>
	
 <!-- Button HTML (to Trigger Modal) -->   
    <div id="myModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content panel-warning">
            	<!-- Icone, texte et entete en warning -->
                <div class="modal-header panel-heading">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <span class="glyphicon glyphicon-warning-sign" aria-hidden="true"> Attention</span>
                </div>
                <div class="modal-body">
                    <p>Vous souhaitez modifier les données suivantes</p>
                    <p class="text-warning dataModifyToMyModal"></p>
                    <p>Elles ne seront pas prises en compte immédiatement à l'écran. Elles seront effectives après la validation de la DRH.</p>
                </div>
                <div class="modal-footer">
                   <button type="button" class="btn btn-default" data-dismiss="modal" onclick="simulateLinkClick('accountForm:saveDataChange');">Fermer</button>
                </div>
            </div>
        </div>
    </div>    
</div><!-- Fin class="container" -->


<h:form id="restart" style="display:none;">
	<e:commandButton id="restartButton" value="#{msgs['APPLICATION.BUTTON.RESTART']}" action="#{exceptionController.restart}" />
</h:form>
</div><!-- Fin class="pc " -->
</e:page>
<script src="../media/scripts/croppie.js"></script>
<script src="../media/scripts/exif.js"></script>
<link rel="stylesheet" href="../media/croppie.css" />
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />
<script src="../media/scripts/croppieForm.js"></script>