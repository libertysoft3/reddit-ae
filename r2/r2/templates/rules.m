## The contents of this file are subject to the Common Public Attribution
## License Version 1.0. (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License at
## http://code.reddit.com/LICENSE. The License is based on the Mozilla Public
## License Version 1.1, but Sections 14 and 15 have been added to cover use of
## software over a computer network and provide for limited attribution for the
## Original Developer. In addition, Exhibit A has been modified to be
## consistent with Exhibit B.
##
## Software distributed under the License is distributed on an "AS IS" basis,
## WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
## the specific language governing rights and limitations under the License.
##
## The Original Code is reddit.
##
## The Original Developer is the Initial Developer.  The Initial Developer of
## the Original Code is reddit Inc.
##
## All portions of the code written by reddit are Copyright (c) 2006-2015
## reddit Inc. All Rights Reserved.
###############################################################################

<%namespace file="utils.m" import="error_field"/>
<%namespace name="utils" file="utils.m"/>

<%!
    from r2.lib.filters import keep_space, unsafe, safemarkdown
%>

<%def name="mod_action_icon(name, title)">
  <span class="mod-action-icon mod-action-icon-${name}"
       title="${title}"
       alt="${title}"></span>
</%def>

<div class="subreddit-rules-page ${'editable' if thing.can_edit else ''}">
    <header class="md-container">
        <div class="md">
            <h2>${thing.title}</h2>
            <p>
                ${_("Rules that visitors must follow to participate. May be used as reasons to report or ban.")}
            </p>
        </div>
    </header>

    <div class="md-container">
        <div id="subreddit-rule-list" class="md">
            %if thing.rules:
                %for rule in thing.rules:
                    <% description_html = unsafe(safemarkdown(rule['description'], wrap=False)) %>
                    <%
                        kind = rule.get('kind', 'all')
                        kind_label = thing.kind_labels.get(kind)
                    %>
                    <div class="subreddit-rule-item"
                         data-priority="${rule['priority']}"
                         data-description="${keep_space(rule['description'])}"
                         data-kind="${kind}">
                        ${self.subreddit_rule(
                            short_name=keep_space(rule['short_name']),
                            description=description_html,
                            kind=kind_label,
                            editable=thing.can_edit,
                        )}
                    </div>
                %endfor
            %endif
        </div>
    </div>

    %if thing.can_edit:
        <footer class="md-container">
            <div id="subreddit-rule-add-form" class="md" hidden>
                <div class="subreddit-rule-add-form-buttons">
                    <button class="subreddit-rule-edit-button">
                        ${self.mod_action_icon('add', _('Add a new rule.'))}&#32;
                        ${_("Add a rule")}
                    </button>
                    <div class="subreddit-rule-too-many-notice" hidden>
                        ${_("You have reached the maximum number of rules.")}
                    </div>
                </div>
            </div>
        </footer>

        <script id="subreddit-rule-template" type="text/template">
            ${self.subreddit_rule(
                short_name=unsafe("<%- short_name %>"),
                description=unsafe("<%= description_html %>"),
                kind=unsafe("<%- kind %>"),
                editable=True,
            )}
        </script>
        <script id="subreddit-rule-form-template" type="text/template">
            ${self.subreddit_rule_form(
                short_name=unsafe("<%- short_name %>"),
                description=unsafe("<%- description %>"),
            )}
        </script>
    %endif
</div>

<%def name="subreddit_rule(short_name='', description='', kind='', editable=False)">
    <div class="subreddit-rule ${'editable' if editable else ''}">
        <div class="subreddit-rule-contents">
            <div class="subreddit-rule-contents-display">
                <h4 class="subreddit-rule-title">
                    ${short_name}
                </h4>
                <div class="subreddit-rule-kind">
                    ${kind}
                </div>
                <div class="subreddit-rule-description">
                    ${description}
                </div>
            </div>
            %if editable:
                <div class="subreddit-rule-buttons">
                    <button class="subreddit-rule-delete-button">
                        ${self.mod_action_icon('delete', _('Delete this rule.'))}
                    </button>
                    <button class="subreddit-rule-edit-button">
                        ${self.mod_action_icon('edit', _('Edit this rule.'))}
                    </button>
                </div>
            %endif
        </div>
        %if editable:
            <div class="md-container-small">
                <div class="subreddit-rule-delete-confirmation" hidden>
                    ${_("Delete this rule?")}&#32;
                    <button class="subreddit-rule-delete-button">${_("delete")}</button>
                    &#32;<span class="separator">|</span>&#32;
                    <button class="subreddit-rule-cancel-button">${_("cancel")}</button>
                </div>
            </div>
        %endif
    </div>
</%def>

<%def name="subreddit_rule_form(short_name='', description='')">
    <form method="post" class="subreddit-rule-form">
        <div class="form-inputs">
            <div class="c-form-group form-group-short_name">
                <div class="md-container-small">
                    <div class="md">
                        <label for="short_name" class="label required">${_("Short name")}</label>
                        <div class="text-counter">
                            <span class="text-counter-display"></span>&#32;
                            ${_("remaining")}
                        </div>
                    </div>
                </div>
                <input type="text" class="c-form-control text-counter-input" name="short_name" value="${short_name}">
                <div class="error-fields">
                    ${error_field("TOO_SHORT", "short_name")}
                    ${error_field("NO_TEXT", "short_name")}
                    ${error_field("TOO_LONG", "short_name")}
                    ${error_field("SR_RULE_EXISTS", "short_name")}
                    ${error_field("SR_RULE_TOO_MANY", "short_name")}
                </div>
            </div>
            <div class="c-form-group form-group-kind">
                <div class="md-container-small">
                    <div class="md">
                        <div class="label">${_("Applies to")}</div>
                        <label>
                            <input type="radio" name="kind" value="all" checked>
                            ${thing.kind_labels.get('all')}
                        </label>
                        <label>
                            <input type="radio" name="kind" value="link">
                            ${thing.kind_labels.get('link')}
                        </label>
                        <label>
                            <input type="radio" name="kind" value="comment">
                            ${thing.kind_labels.get('comment')}
                        </label>
                        ${error_field("INVALID_OPTION", "kind")}
                    </div>
                </div>
            </div>
            <div class="c-form-group form-group-description">
                <div class="md-container-small">
                    <div class="md">
                        <label class="label" for="description">${_("Full description of this rule")}</label>
                        <div class="text-counter">
                            <span class="text-counter-display" rel="description"></span>&#32;
                            ${_("remaining")}
                        </div>
                    </div>
                </div>
                <textarea class="c-form-control text-counter-input" name="description" rows=4>${description}</textarea>
                <div class="error-fields">
                    ${error_field("TOO_LONG", "description")}
                </div>
            </div>
        </div>
        <div class="form-buttons">
            <button type="reset" class="subreddit-rule-cancel-button">
                ${self.mod_action_icon('cancel', _('Cancel this action.'))}
            </button>
            <button type="submit" class="subreddit-rule-submit-button">
                ${self.mod_action_icon('confirm', _('Confirm this action.'))}
            </button>
        </div>
        ${error_field("UNKNOWN_ERROR", "unknown")}
    </form>
</%def>
