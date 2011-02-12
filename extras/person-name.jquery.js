/**
 * JQuery widget for the formtastic person-name field
 * This widget adds an 'expand' button to the name field to popup a dialog to edit all individual fields
 *
 * Usage:
 *   // Init person names
 *   $('form.formtastic input.person-name').personName({
 *       lookupUrl: "/people/split-name.json",
 *       formClass: "formtastic"
 *   });
 *
 * In the PeopleController:
 *
 * def split_name
 *   @result = PersonName::NameSplitter.split(params[:name], params[:values])
 *   respond_with(@result) do |format|
 *     format.json { render :text => @result.to_json }
 *   end
 * end
 *
 *
 */
(function($, undefined) {

    $.widget("ui.personName", {
        options: {
            lookupUrl: "",
            dialogId: "person-name-detail-edit-dialog",
            labels: {
                prefix: "Voorvoegsel",
                firstName: "Voornaam",
                middleName: "Extra voornamen",
                intercalation: "Tussenvoegsel",
                lastName: "Achternaam",
                suffix: "Achtervoegsel",
                dialogButton: "Naam bewerken"
            },
            dialog: {
                ajaxErrorMessage: "Naam informatie kon niet automatisch worden gesplitst."
            },
            formClass: ""
        },
        nameFields: ["prefix", "first_name", "middle_name", "intercalation", "last_name", "suffix"],
        _create: function() {
            this.element.after(" <a href=\"#edit-name\">" + this.options.labels.dialogButton + "</a>");

            this.originalFieldLabel = $("label[for=" + this.element.attr("id") + "]").html();
            this.element.parent().find("a:first").button({
                text: false,
                icons: {
                    primary: "ui-icon-newwin"
                }
            }).bind("click", this, this._editClick);
        },
        destroy: function() {
            this.element.parent().find("a:first").unblind("click", this._editClick);
            $.Widget.prototype.destroy.apply(this, arguments);
        },
        _editClick: function(event) {
            if (event.data.options.lookupUrl != "") {
                event.data._requestAndBuildDialog();
            } else {
                event.data._buildDialog();
            }
            return false;
        },
        _requestAndBuildDialog: function() {
            var nameData = { "_method": "PUT"};
            var prefix = "name";
            nameData[prefix] = this.element.val();
            nameData["values"] = {};
            for (var index in this.nameFields) {
                var fieldId = this.element.attr("id") + "_" + this.nameFields[index];
                nameData.values[this.nameFields[index]] = $("#" + fieldId).val();
            }
            var self = this;
            $.ajax({
                data: nameData,
                dataType: "json",
                success: function(data, textStatus, XMLHttpRequest) {
                    for (var index in self.nameFields) {
                        var fieldId = self.element.attr("id") + "_" + self.nameFields[index];
                        $("#" + fieldId).val(data[self.nameFields[index]] || "");
                    }
                    self._buildDialog();
                },
                error: function() {
                    alert(self.options.dialog.ajaxErrorMessage);
                    self._buildDialog();
                },
                type: "GET",
                url: this.options.lookupUrl
            });

        },
        _buildDialog: function() {
            var fieldIdPrefix = "edit_" + this.element.attr("id");
            /**
             * Mimic the html syntax from formtastic
             */
            var dialogCode = "<div id=\"" + this.options.dialogId + "\">";
            dialogCode += "<form class=\"" + this.options.formClass + "\"><fieldset><ol>";
            for (var index in this.nameFields) {
                var dialogFieldId = fieldIdPrefix + "_" + this.nameFields[index];
                var fieldId = this.element.attr("id") + "_" + this.nameFields[index];

                var labelName = this.nameFields[index].replace(/(\_[a-z])/g, function($1) { return $1.toUpperCase().replace('_',''); });
                dialogCode += "<li><label for=\"" + dialogFieldId + "\">" + this.options.labels[labelName] + "</label>" +
                        "<input type=\"text\" id=\"" + dialogFieldId + "\" value=\"" + $("#" + fieldId).val() + "\">" +
                        "</li>";
            }
            dialogCode += "</ol></fieldset></form></div>";
            this.element.after(dialogCode);

            var self = this;
            this.element.parent().find("#" + this.options.dialogId).dialog({
                title: this.originalFieldLabel + " details bewerken",
                buttons: {
                    "Opslaan en sluiten": function() {
                        self._storeDialog();
                        $(this).remove();
                    },
                    "Annuleren": function() {
                        $(this).dialog("close").remove();
                    }
                },
                modal: true
            });
        },
        _storeDialog: function() {
            var fieldIdPrefix = "edit_" + this.element.attr("id");
            var values = [];
            for (var index in this.nameFields) {
                var dialogFieldId = fieldIdPrefix + "_" + this.nameFields[index];
                var fieldId = this.element.attr("id") + "_" + this.nameFields[index];
                var fieldValue = $("#" + dialogFieldId).val();
                if (fieldValue != "") values.push(fieldValue);
                $("#" + fieldId).val(fieldValue);
            }
            $(this.element).val(values.join(" "));
        }
    });

    $.extend($.ui.personName, {
        version: "1.0"
    });

})(jQuery);
