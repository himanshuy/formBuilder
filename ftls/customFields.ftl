<!-- This algorithm is the heart of the form layout. It is third algorithm I came up with to build a proper section layout.
It builds the section layout based on if a field has to be in a single row or two columns. -->
<#macro columnate fields>
  <#local inCol1 = true>
  <#list fields as field>
    <#local fullRow = isFullRow(field)>

    <#if inCol1 || fullRow>
      <div class="row field"> <!-- row starts --->
    </#if>

    <#if !fullRow>
      <div class="col-xs-6 col-sm-6 col-md-6 form-inline"> <!-- column ${inCol1?string('1', '2')} -->
    </#if>
    <@customFields.createField field=field />
    <#if !fullRow>
      </div>
    </#if>

    <#if !inCol1 || fullRow || !field_has_next || isFullRow(fields[field_index + 1])>
      </div> <!-- row ends -->
    </#if>

    <#local inCol1 = !inCol1 || fullRow>
  </#list>
</#macro>

<!-- Tells if a field is at row level or not. -->
<#function isFullRow field>
  <#return field.@type == 'agreement' || field.@type == 'note' || field.@type == "address" || field.@type == "multiselect"/>
</#function>

<!-- It actually builds the HTML elements based on Form XML -->
<#macro createField field>
  <#if field.@type=="agreement">
  	 <@customFields.createAgreementField field=field/>
  <#elseif field.@type=="checkbox">
  	    <@customFields.createCheckboxField field=field/>
  <#elseif field.@type == "address">
	  		<@customFields.createAddressField field=field/>
  <#elseif field.@type == "description">
	  		<@customFields.createTextAreaField field=field/>
  <#elseif field.@type == "note">
	  		<@customFields.createNoteField field=field/>
  <#elseif field.@type == "multiselect">
	  		<@customFields.createMultiSelectField field=field/>
  <#else>
	  	<@customFields.createFieldLabel field=field/>
	  	<#if field.@type == "text">
	  		<@customFields.createTextfield field=field />
	  	<#elseif field.@type == "date">
	  		<@customFields.createdatefield field=field />
	  	<#elseif field.@type == "select">
	  		<@customFields.createCodeTableField field=field/>
	  	<#elseif field.@type == "button">
	  		<@customFields.createButtonField field=field/>
	  	<#else>
			<@customFields.createSpecialTextField field=field/>
	  	</#if>
  </#if>
</#macro>

<#macro createCodeTableField field>
		<#assign codeTableList = codeTableWrapper.getCodeTableEntries(field.@codeTableName,0)/>
	    	<select name="${field.@name}">
	    		<option value="" selected="selected">None selected</option>
	    		<#list codeTableList as codeTable>
	    			<option value="${codeTable.code}">${codeTable.codeDesc}</option>
	    		</#list>
	    	</select>
</#macro>
<#macro createFieldLabel field>
	<#if field.@label[0]??>
  		<label class="pocLabel">
  		<#if field.@mandatory[0]?? && field.@mandatory == "yes">
  			<span style="color:red;">*</span>
  		</#if>
  		${field.@label}</label>
	 </#if>
</#macro>
<#macro createAgreementField field>
	<p class="agreement">${field.@value}</p>
	<div class="pull-center">
		<label class="radio">
		  <input type="radio" name="${field.@name}-optionsRadios" id="optionsRadios1" value="option1" checked>
		  Agree
		</label>
		<label class="radio">
		  <input type="radio" name="${field.@name}-optionsRadios" id="optionsRadios2" value="option2">
		  Disagree
		</label>
	</div>
</#macro>
<#macro createCheckboxField field>
   <div class="row field">
	<@createFieldLabel field=field/>
	<#list field.@values?split(":") as value>
	 	 <input type="checkbox"> ${value}
	 </#list>
	</div>
</#macro>
<#macro createTextfield field>
	<input type="text"
		name="${field.@name}" class="form-control"
		<@commanFieldAttributes field/>
	/>
	<@commonFieldValidations field/>
</#macro>
<#macro createSpecialTextField field>
	<input type="text"
		name="${field.@name}"
		class="form-control
		<#if field.@type=="amount"> 
			amount"
		<#elseif field.@type=="email">
			email"
		</#if>
		<@commanFieldAttributes field/>
	/>
	<@commonFieldValidations field/>
</#macro>
<#macro createdatefield field>
	<input type="text"
		name="${field.@name}" class="datePicker"
		<@commanFieldAttributes field/>
	/>
	<@commonFieldValidations field/>
</#macro>
<#macro createQuestionField field>
 <div class="row">
   <p>${field.@label}</p>
   <div class="form-inline">
   		<div class="radio">
   		  <label><input type="radio" name="optionsRadios" id="optionsRadios1" value="option1">Yes</label>
   		  <label><input type="radio" name="optionsRadios" id="optionsRadios2" value="option2">No</label>
   		</div>
   </div>
 </div>
</#macro>
<#macro createamountfield field>
	<input type="text"
		name="${field.@name}" class="form-control amount"
		<@commanFieldAttributes field/>
	/>
	<@commonFieldValidations field/>
</#macro>
<#macro createButtonField field>
	<button type="button" id="${field.@name}" class="btn btn-primary pull-right">${field.@value}</button>
</#macro>
<#macro createAddressField field>
	<div class="row field address">
		<div class="col-xs-6 col-sm-6 col-md-6 form-inline">
  			<label class="pocLabel">Address Line 1</label>
			<input type="text" name="address" class="form-control">
		</div>
		<div class="col-xs-6 col-sm-6 col-md-6 form-inline">
  			<label class="pocLabel">Address Line 2</label>
			<input type="text" name="address" class="form-control">
		</div>
	</div>
	<div class="row field address">
		<div class="col-xs-6 col-sm-6 col-md-6 form-inline">
  			<label class="pocLabel">City</label>
			<input type="text" name="address" class="form-control">
		</div>
		
	</div>
	<div class="row field address">
		<div class="col-xs-6 col-sm-6 col-md-6 form-inline">
  			<label class="pocLabel">Zip Code</label>
			<input type="text" name="address" class="form-control">
		</div>
		
	</div>
</#macro>
<#macro createTextAreaField field>
	<textarea class="form-control" style="margin-top:10px;" name="${field.@name}" rows="3"></textarea>
</#macro>
<#macro createNoteField field>
	<div class="alert alert-info" id="note"><strong>Note: </strong>${field.@label}</div>
</#macro>
<#macro createMultiSelectField field>
	<@customFields.createFieldLabel field=field/>
	<#assign codeTableList = codeTableWrapper.getCodeTableEntries(field.@codeTableName,0)/>
	<select name="${field.@name}" name="${field.@name}" class="multiselect" multiple="multiple">
		<#list codeTableList as codeTable>
			<option value="${codeTable.code}">${codeTable.codeDesc}</option>
		</#list>
	</select>
</#macro>
<#macro commanFieldAttributes field>
	<#if field.@mandatory[0]?? && field.@mandatory == "yes">
			required
	</#if>
</#macro>
<#macro commonFieldValidations field>
	<#if field.@praseValidation[0]?? && field.@praseValidation == "yes">
		<span class="badge">P</span>
	</#if>
</#macro>

