<%--
~ Copyright (c) 2005-2014, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
~
~ WSO2 Inc. licenses this file to you under the Apache License,
~ Version 2.0 (the "License"); you may not use this file except
~ in compliance with the License.
~ You may obtain a copy of the License at
~
~    http://www.apache.org/licenses/LICENSE-2.0
~
~ Unless required by applicable law or agreed to in writing,
~ software distributed under the License is distributed on an
~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
~ KIND, either express or implied.  See the License for the
~ specific language governing permissions and limitations
~ under the License.
--%>
<%@ page import="java.util.ResourceBundle" %>

<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:bundle basename="org.wso2.carbon.event.processor.ui.i18n.Resources">

<carbon:breadcrumb
        label="edit"
        resourceBundle="org.wso2.carbon.event.processor.ui.i18n.Resources"
        topPage="false"
        request="<%=request%>"/>

<script type="text/javascript" src="../admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../admin/js/cookies.js"></script>
<script type="text/javascript" src="../admin/js/main.js"></script>

<script type="text/javascript" src="global-params.js"></script>

<script src="../editarea/edit_area_full.js" type="text/javascript"></script>

<link type="text/css" href="../dialog/js/jqueryui/tabs/ui.all.css" rel="stylesheet"/>
<script type="text/javascript" src="../dialog/js/jqueryui/tabs/jquery-1.2.6.min.js"></script>
<script type="text/javascript"
        src="../dialog/js/jqueryui/tabs/jquery-ui-1.6.custom.min.js"></script>
<script type="text/javascript" src="../dialog/js/jqueryui/tabs/jquery.cookie.js"></script>
<script type="text/javascript" src="../ajax/js/prototype.js"></script>

<%--Yahoo includes for dom event handling--%>
<script src="../yui/build/yahoo-dom-event/yahoo-dom-event.js" type="text/javascript"></script>

<%--end of newly added--%>


<%
    String status = request.getParameter("status");
    ResourceBundle bundle = ResourceBundle.getBundle(
            "org.wso2.carbon.event.processor.ui.i18n.Resources", request.getLocale());

    if ("updated".equals(status)) {
%>
<script type="text/javascript">
    jQuery(document).ready(function () {
        CARBON.showInfoDialog('<%=bundle.getString("activated.configuration")%>');
    });
</script>
<%

    }
%>

<%
    String execPlanName = request.getParameter("execPlanName");
    String execPlanPath = request.getParameter("execPlanPath");
%>

<script type="text/javascript">
    function updateConfiguration(form, executionPlanName) {
        var newExecutionPlan = "";

        if (document.getElementById("queryExpressions") != null) {
            newExecutionPlan =   window.queryEditor.getValue();
        }

        var parameters = "?execPlanName=" + executionPlanName + "&execPlan=" + newExecutionPlan;

        new Ajax.Request('../eventprocessor/edit_execution_plan_ajaxprocessor.jsp', {
            method: 'POST',
            asynchronous: false,
            parameters: {execPlanName: executionPlanName, execPlan: newExecutionPlan },
            onSuccess: function (transport) {
                if ("true" == transport.responseText.trim()) {
                    form.submit();
                } else {
                    if(transport.responseText.trim().indexOf("The input stream for an incoming message is null") != -1){
                        CARBON.showErrorDialog("Possible session time out, redirecting to index page",function(){
                            window.location.href = "../admin/index.jsp?ordinal=1";
                        });
                    }else{
                        CARBON.showErrorDialog("Exception: " + transport.responseText.trim());
                    }
                }
            }
        });

    }

    function updateNotDeployedConfiguration(form, executionPlanPath) {
        var newExecutionPlan = "";

        if (document.getElementById("queryExpressions") != null) {
            newExecutionPlan =  window.queryEditor.getValue();
        }

        new Ajax.Request('../eventprocessor/edit_execution_plan_ajaxprocessor.jsp', {
            method: 'POST',
            asynchronous: false,
            parameters: {execPlanPath: executionPlanPath, execPlan: newExecutionPlan },
            onSuccess: function (transport) {
                if ("true" == transport.responseText.trim()) {
                    form.submit();
                } else {
                    if(transport.responseText.trim().indexOf("The input stream for an incoming message is null") != -1){
                        CARBON.showErrorDialog("Possible session time out, redirecting to index page",function(){
                            window.location.href = "../admin/index.jsp?ordinal=1";
                        });
                    }else{
                        CARBON.showErrorDialog("Exception: " + transport.responseText.trim());
                    }
                }
            }
        });

    }

    function resetConfiguration(form) {

        CARBON.showConfirmationDialog(
                "Are you sure you want to reset?", function () {
                    editAreaLoader.setValue("rawConfig", document.getElementById("rawConfig").value.trim());
                });

    }

</script>

<div id="middle">
    <h2><fmt:message key="edit.execution.plan.configuration"/></h2>

    <div id="workArea">
        <form name="configform" id="configform" action="index.jsp?ordinal=1" method="post">
            <div id="saveConfiguration">
                            <span style="margin-top:10px;margin-bottom:10px; display:block;_margin-top:0px;">
                                <fmt:message key="save.advice"/>
                            </span>
            </div>
            <table class="styledLeft noBorders spacer-bot" style="width:100%">
                <thead>
                <tr>
                    <th colspan="2">
                        <fmt:message key="execution.plan.configuration"/>
                    </th>
                </tr>
                </thead>
                <tbody>
                <%@include file="inner_execution_plan_ui.jsp" %>
                <tr>
                    <td class="buttonRow">
                        <%
                            if (execPlanName != null) {
                        %>

                        <button class="button"
                                onclick="updateConfiguration(document.getElementById('configform'),'<%=execPlanName%>'); return false;">
                            <fmt:message
                                    key="update"/></button>

                        <%
                        } else if (execPlanPath != null) {
                        %>
                        <button class="button"
                                onclick="updateNotDeployedConfiguration(document.getElementById('configform'),'<%=execPlanPath%>'); return false;">
                            <fmt:message
                                    key="update"/></button>

                        <%
                            }
                        %>
                        <button class="button"
                                onclick="resetConfiguration(document.getElementById('configform')); return false;">
                            <fmt:message
                                    key="reset"/></button>
                    </td>
                </tr>
                </tbody>

            </table>

        </form>

    </div>
</div>
</fmt:bundle>