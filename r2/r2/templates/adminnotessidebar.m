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
<%namespace file="utils.m" import="md" />
<%namespace file="utils.m" import="timestamp" />

<div class="raisedbox spacer">
    ${_(thing.SYSTEMS[thing.system])}: ${thing.subject}
    %if thing.system == 'user':
        <br/>
        ${_('global ban')}: ${thing.global_ban}
    %endif
    <form id="adminnotes-form" method="post" action="/api/add_admin_note"
        onsubmit="return post_form(this, 'add_admin_note')">
        <input type="hidden" name="system" value="${thing.system}">
        <input type="hidden" name="subject" value="${thing.subject}">
        <input type="hidden" name="author" value="${thing.author}">
        <textarea name="note" rows=4></textarea>
        ${error_field("TOO_LONG", "notes", "span")}
        <input type="submit" class="notes-button" value="Add a new Note">
    </form>
    %if thing.notes:
        ${_("Past notes")}:
        <ul id="past-notes">
            %for note in thing.notes:
            <li class="adminnote">
                <div class="adminnote-text">
                ${md(note["note"])}
                </div>
                <div class="adminnote-info tagline">
                ${_("by %(author)s") % dict(
                    author=note["author"],
                )}&nbsp;
                ${timestamp(note["when"], include_tense=True)}
                </div>
            </li>
            %endfor
        </ul>
    %else:
        ${_(thing.EMPTY_MESSAGE[thing.system])}
    %endif
</div>
