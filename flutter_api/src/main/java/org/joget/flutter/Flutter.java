
package org.joget.flutter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import org.joget.api.annotations.Operation;
import org.joget.api.annotations.Param;
import org.joget.api.annotations.Response;
import org.joget.api.annotations.Responses;
import org.joget.api.model.ApiDefinition;
import org.joget.api.model.ApiPluginAbstract;
import org.joget.api.model.ApiResponse;
import org.joget.apps.app.dao.FormDefinitionDao;
import org.joget.apps.app.model.AppDefinition;
import org.joget.apps.app.model.FormDefinition;
import org.joget.apps.app.model.PackageActivityForm;
import org.joget.apps.app.service.AppPluginUtil;
import org.joget.apps.app.service.AppUtil;
import org.joget.apps.form.lib.FormOptionsBinder;
import org.joget.apps.form.model.Element;
import org.joget.apps.form.model.Form;
import org.joget.apps.form.model.FormData;
import org.joget.apps.form.model.FormLoadBinder;
import org.joget.apps.form.model.FormRowSet;
import org.joget.apps.form.service.FormService;
import org.joget.apps.form.service.FormUtil;
import org.joget.apps.app.service.AppService;
import java.util.List;

import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.util.WorkflowUtil;
import org.json.JSONObject;

import com.google.gson.JsonObject;

public class Flutter extends ApiPluginAbstract {

    public static final String MESSAGE_PATH = "messages/Flutter";

    @Override
    public String getName() {
        return "Flutter";
    }

    @Override
    public String getVersion() {
        return "1.0.0";
    }

    @Override
    public String getDescription() {
        return AppPluginUtil.getMessage(getName() + ".desc", getClassName(), getResourceBundlePath());
    }

    @Override
    public String getLabel() {
        return AppPluginUtil.getMessage(getName() + ".label", getClassName(), getResourceBundlePath());
    }

    @Override
    public String getClassName() {
        return getClass().getName();
    }

    @Override
    public String getPropertyOptions() {
        return AppUtil.readPluginResource(getClass().getName(), "/properties/api/" + getName() + ".json", null, true,
                getResourceBundlePath());
    }

    @Override
    public String getIcon() {
        return "<i class=\"fas fa-mobile\"></i>";
    }

    @Override
    public String getTag() {
        return "flutter";
    }

    @Override
    public String getTagDesc() {
        return AppPluginUtil.getMessage(getName() + ".tagDesc", getClassName(), getResourceBundlePath());
    }

    @Override
    public String getResourceBundlePath() {
        return MESSAGE_PATH;
    }

    // << START >> Get Form ID by passing Process Def ID
    @Operation(path = "/getFormId", type = Operation.MethodType.GET, summary = "getFormId", description = "getFormId")
    @Responses({
            @Response(responseCode = 200, description = "@@Flutter.resp.200@@"),
            @Response(responseCode = 404, description = "@@Flutter.resp.404@@")
    })
    public ApiResponse getFormId(
            @Param(value = "processDefId", description = "processDefId") String processDefId) {
        FormData formData = new FormData();
        AppService appService = (AppService) AppUtil.getApplicationContext().getBean("appService");
        try {
            AppDefinition appDef = AppUtil.getCurrentAppDefinition();
            String appVersion = appService.getPublishedVersion(appDef.getAppId()).toString();
            PackageActivityForm startFormDef = appService.viewStartProcessForm(appDef.getAppId(),
                    appVersion, processDefId, formData, "");
            Form startForm = startFormDef.getForm();
            HashMap<String, String> responseContent = new HashMap<>();
            responseContent.put("formId", startForm.getProperty("id").toString());
            return new ApiResponse(200, responseContent);
        } catch (Exception e) {
            return new ApiResponse(404, "@@Flutter.resp.404@@");
        }
    }
    // << END >> Get Form ID by passing Process Def ID

    // << START >> Get options in a SelectBox by passing Form ID and Field ID
    @Operation(path = "/getSelectBoxOptions", type = Operation.MethodType.GET, summary = "getSelectBoxOptions", description = "getSelectBoxOptions")
    @Responses({
            @Response(responseCode = 200, description = "@@Flutter.resp.200@@"),
            @Response(responseCode = 404, description = "@@Flutter.resp.404@@")
    })
    public ApiResponse getSelectBoxOptions(
            @Param(value = "formId", description = "formId") String formId,
            @Param(value = "fieldId", description = "fieldId") String fieldId) {
        try {
            Collection<Map> optionsMap = new ArrayList();
            FormDefinitionDao formDefinitionDao = (FormDefinitionDao) AppUtil.getApplicationContext()
                    .getBean("formDefinitionDao");
            FormService formService = (FormService) AppUtil.getApplicationContext().getBean("formService");
            AppDefinition appDef = AppUtil.getCurrentAppDefinition();
            FormDefinition formDef = formDefinitionDao.loadById(formId, appDef);
            Element e = null;
            if (formDef != null) {
                Form form = (Form) formService.createElementFromJson(formDef.getJson(),
                        true);
                e = FormUtil.findElement(fieldId, form, null);
            }
            FormData formData = new FormData();
            FormData formData2 = new FormData();
            FormData formData3 = new FormData();
            formData2 = formService.executeFormOptionsBinders(e, formData);
            formData3 = FormUtil.executeOptionBinders(e, formData2);
            FormRowSet rowSet = formData3.getOptionsBinderData(e, "");
            if (rowSet != null) {
                Iterator var13 = rowSet.iterator();
                while (var13.hasNext()) {
                    Map row = (Map) var13.next();
                    optionsMap.add(row);
                }
            }
            if (optionsMap.isEmpty()) {
                optionsMap = FormUtil.getElementPropertyOptionsMap(e, new FormData());
            }
            HashMap<String, Collection<Map>> responseContent = new HashMap<>();
            responseContent.put("options", optionsMap);
            return new ApiResponse(200, responseContent);
        } catch (Exception e) {
            return new ApiResponse(404, "@@Flutter.resp.404@@");
        }
    }
    // << END >> Get options in a SelectBox by passing Form ID and Field ID

    // << START >> Get Hash Value by passing Hash Variable
    @Operation(path = "/getHashValue", type = Operation.MethodType.GET, summary = "getHashValue", description = "getHashValue")
    @Responses({
            @Response(responseCode = 200, description = "@@Flutter.resp.200@@"),
            @Response(responseCode = 404, description = "@@Flutter.resp.404@@")
    })
    public ApiResponse getHashValue(
            @Param(value = "hashVariable", description = "hashVariable") String hashVariable) {
        try {
            String hashValue = WorkflowUtil.processVariable(hashVariable, "", new WorkflowAssignment());
            // JSONObject responseContent = new JSONObject();
            // responseContent.put("hashValue", hashValue);
            HashMap<String, String> responseContent = new HashMap<>();
            responseContent.put("hashValue", hashValue);
            return new ApiResponse(200, responseContent);
        } catch (Exception e) {
            return new ApiResponse(404, "@@Flutter.resp.404@@");
        }
    }
    // << END >> Get Hash Value by passing Hash Variable

}