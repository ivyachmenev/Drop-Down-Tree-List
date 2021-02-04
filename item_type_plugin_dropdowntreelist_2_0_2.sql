set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,2528307577003643));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'ru'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,104);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/dropdowntreelist
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'DROPDOWNTREELIST'
 ,p_display_name => 'Drop Down Tree List'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'/*'||unistr('\000a')||
'  Drop Down Tree List Plug-in'||unistr('\000a')||
''||unistr('\000a')||
'  See plug-in documentation for more information.'||unistr('\000a')||
'*/'||unistr('\000a')||
''||unistr('\000a')||
'function render_tree_list ('||unistr('\000a')||
'  p_item                in apex_plugin.t_page_item,'||unistr('\000a')||
'  p_plugin              in apex_plugin.t_plugin,'||unistr('\000a')||
'  p_value               in varchar2,'||unistr('\000a')||
'  p_is_readonly         in boolean,'||unistr('\000a')||
'  p_is_printer_friendly in boolean )'||unistr('\000a')||
'return apex_plugin.t_page_item_render_result'||unistr('\000a')||
'as'||unistr('\000a')||
'  l_value                '||
' varchar2(32767) := p_value;'||unistr('\000a')||
'  l_display_value         varchar2(32767);'||unistr('\000a')||
'  l_result                wwv_flow_plugin.t_page_item_render_result;'||unistr('\000a')||
'  l_cur_app               number := :APP_ID;'||unistr('\000a')||
'  l_cur_page              number := :APP_PAGE_ID;'||unistr('\000a')||
''||unistr('\000a')||
'  l_tree_static_id        varchar2(30) := p_item.attribute_01;'||unistr('\000a')||
'  l_tree_id               varchar2(30);'||unistr('\000a')||
'  l_alt                   varchar2(32767) := p_item.attribut'||
'e_02;'||unistr('\000a')||
'  l_page_item_to_return   varchar2(30);'||unistr('\000a')||
'  l_page_item_to_return_cond number(1) := p_item.attribute_03;'||unistr('\000a')||
''||unistr('\000a')||
'  l_hidden_element_id     varchar2(30) := p_item.name;'||unistr('\000a')||
'  l_hidden_element_name   varchar2(30) := apex_plugin.get_input_name_for_page_item(false);'||unistr('\000a')||
''||unistr('\000a')||
'  l_display_element_name  varchar2(30) := p_item.name || ''_display'';'||unistr('\000a')||
'  l_display_block_id      varchar2(30) := p_item.name || ''_block'';'||unistr('\000a')||
''||unistr('\000a')||
'  l_tm'||
'p                   varchar2(32767);'||unistr('\000a')||
'  l_theme                 varchar2(255);'||unistr('\000a')||
'  l_icon                  varchar2(4000);'||unistr('\000a')||
''||unistr('\000a')||
'  l_tree_attributes       varchar2(4000) := p_plugin.attribute_01;'||unistr('\000a')||
'  l_auto_size             number := to_number( p_plugin.attribute_02 );'||unistr('\000a')||
'  l_remove_icons          char(1) := p_item.attribute_06;'||unistr('\000a')||
'  l_auto_expand           varchar2(5) := p_item.attribute_05;'||unistr('\000a')||
''||unistr('\000a')||
'  l_engine         '||
'       varchar2(255); -- APEX_TREE / JSTREE / PLUGIN '||unistr('\000a')||
'begin'||unistr('\000a')||
'  -- print debug information'||unistr('\000a')||
'  if apex_application.g_debug then'||unistr('\000a')||
''||unistr('\000a')||
'      apex_plugin_util.debug_page_item ('||unistr('\000a')||
'          p_plugin              => p_plugin,'||unistr('\000a')||
'          p_page_item           => p_item,'||unistr('\000a')||
'          p_value               => l_value,'||unistr('\000a')||
'          p_is_readonly         => p_is_readonly,'||unistr('\000a')||
'          p_is_printer_friendly => p_is_printer_frie'||
'ndly );'||unistr('\000a')||
''||unistr('\000a')||
'    apex_css.add_file ( p_name => ''ddtl'''||unistr('\000a')||
'                      , p_directory => p_plugin.file_prefix );'||unistr('\000a')||
''||unistr('\000a')||
'    apex_javascript.add_library ( p_name => ''ddtl'''||unistr('\000a')||
'                                , p_directory => p_plugin.file_prefix );'||unistr('\000a')||
'  else'||unistr('\000a')||
'    apex_css.add_file ( p_name => ''ddtl.min'''||unistr('\000a')||
'                      , p_directory => p_plugin.file_prefix );'||unistr('\000a')||
''||unistr('\000a')||
'    apex_javascript.add_library ( p_name => ''d'||
'dtl.min'''||unistr('\000a')||
'                                , p_directory => p_plugin.file_prefix );'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  -- add inline css to hide tree region'||unistr('\000a')||
'  apex_css.add ( '||unistr('\000a')||
'    p_css => ''#'' || l_tree_static_id || '' { '' || l_tree_attributes || '' }'','||unistr('\000a')||
'    p_key => null'||unistr('\000a')||
'  );'||unistr('\000a')||
''||unistr('\000a')||
'  -- select apex dictionary for data.  tree id is necessary for functions like apex.widget.tree.expand_all (note: l_tree_static_id doesn''t fit)'||unistr('\000a')||
'  beg'||
'in'||unistr('\000a')||
'    select decode(t.tree_id,null,to_char(null),''tree'' || to_char(t.tree_id))'||unistr('\000a')||
''||unistr('\000a')||
'         , case when r.attribute_07 is null and t.tree_id is null then r.attribute_01'||unistr('\000a')||
'                                                                  else t.tree_selected_node'||unistr('\000a')||
'           end              '||unistr('\000a')||
''||unistr('\000a')||
'         , case '||unistr('\000a')||
'             when r.attribute_07 = ''APEX_TREE'' then r.attribute_08'||unistr('\000a')||
'             when r.attribu'||
'te_07 = ''JSTREE''    then t.tree_template'||unistr('\000a')||
'             when t.tree_id is null            then ''classic'''||unistr('\000a')||
'             else                                   t.tree_template'||unistr('\000a')||
'           end'||unistr('\000a')||
''||unistr('\000a')||
'         , case '||unistr('\000a')||
'             when r.attribute_07 is not null                        then r.attribute_07'||unistr('\000a')||
'             when r.attribute_07 is null and  t.tree_id is not null then ''JSTREE'''||unistr('\000a')||
'             when r.attrib'||
'ute_07 is null and  t.tree_id is null     then ''PLUGIN'''||unistr('\000a')||
'           end'||unistr('\000a')||
''||unistr('\000a')||
'      into l_tree_id, l_page_item_to_return, l_theme, l_engine'||unistr('\000a')||
'    from apex_application_page_regions r'||unistr('\000a')||
'       , apex_application_page_trees t'||unistr('\000a')||
'    where r.region_id = t.region_id(+)'||unistr('\000a')||
'      and r.static_id = l_tree_static_id'||unistr('\000a')||
'      and r.page_id = l_cur_page'||unistr('\000a')||
'      and r.application_id = l_cur_app;'||unistr('\000a')||
''||unistr('\000a')||
'  exception when no_data_found '||
'then '||unistr('\000a')||
'    raise_application_error(-20000, ''Tree Region with StaticID="'' || l_tree_static_id || ''" is not found.'');'||unistr('\000a')||
'  end;'||unistr('\000a')||
' '||unistr('\000a')||
'  -- print display only element'||unistr('\000a')||
'  -- two modes are supported: readonly and normal both contain hidden and readonly elements'||unistr('\000a')||
'  if p_is_readonly or p_is_printer_friendly then'||unistr('\000a')||
''||unistr('\000a')||
'    -- print hidden element'||unistr('\000a')||
'    htp.prn(''<input type="hidden" id="'' || l_hidden_element_id || ''" name='||
'"'' || l_hidden_element_name  || ''" value="'' || l_value || ''" />'');'||unistr('\000a')||
''||unistr('\000a')||
'    -- print display element'||unistr('\000a')||
'    if l_engine = ''APEX_TREE'' then'||unistr('\000a')||
''||unistr('\000a')||
'      -- Default for l_theme: ''a-Icon'''||unistr('\000a')||
'      l_display_value := '||unistr('\000a')||
'         ''<span class="ddtl_display_block ddtl_readonly" id="'' || l_display_block_id || ''">'''||unistr('\000a')||
'      ||   ''<span class="ddtl_image_'' || l_theme || '' '' || l_theme || '' '' || ''icon-tree-folder"></span>'''||unistr('\000a')||
'    '||
'  ||   ''<span class="ddtl_text">'' || apex_plugin_util.escape ( p_value => l_value, p_escape => true ) || ''</span>'''||unistr('\000a')||
'      || ''</span>'';'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_display_value := '||unistr('\000a')||
'         ''<span class="ddtl_display_block ddtl_readonly" id="'' || l_display_block_id || ''">'''||unistr('\000a')||
'      ||   ''<span class="ddtl_image_'' || l_theme || ''"></span>'''||unistr('\000a')||
'      ||   ''<span class="ddtl_text">'' || apex_plugin_util.escape ( p_valu'||
'e => l_value, p_escape => true ) || ''</span>'''||unistr('\000a')||
'      || ''</span>'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  else'||unistr('\000a')||
''||unistr('\000a')||
'    -- initialization'||unistr('\000a')||
'    -- we need to place this code at the end of queue so that it will be executed after standard tree initialization'||unistr('\000a')||
'    -- so we are placing document ready in onload'||unistr('\000a')||
'    apex_javascript.add_onload_code('''||unistr('\000a')||
''||unistr('\000a')||
'      apex.jQuery(document).ready(function() {'||unistr('\000a')||
''||unistr('\000a')||
'        ddtl_init( "'' || l_tree_id || '||
'''"'||unistr('\000a')||
'                 , "'' || l_tree_static_id || ''"'||unistr('\000a')||
'		 , "'' || l_display_block_id || ''"'||unistr('\000a')||
'		 , "'' || l_hidden_element_id || ''"'||unistr('\000a')||
'			  '||unistr('\000a')||
'		 , "'' || l_page_item_to_return || ''"'||unistr('\000a')||
'				  '||unistr('\000a')||
'		 , "'' || l_engine || ''"'||unistr('\000a')||
'		 , "'' || l_theme || ''"'||unistr('\000a')||
'				  '||unistr('\000a')||
'		 , "'' || l_remove_icons || ''"'||unistr('\000a')||
'		 , "'' || l_auto_expand || ''"'||unistr('\000a')||
'		 , "'' || l_auto_size || ''" );'||unistr('\000a')||
'      });'||unistr('\000a')||
'    '');'||unistr('\000a')||
''||unistr('\000a')||
'    -- print hidden element'||unistr('\000a')||
'    htp.prn(''<input type'||
'="hidden" id="'' || l_hidden_element_id || ''" name="'' || l_hidden_element_name  || ''" value="'' || l_value || ''" />'');'||unistr('\000a')||
''||unistr('\000a')||
'    -- print display element'||unistr('\000a')||
'    if l_engine = ''APEX_TREE'' then'||unistr('\000a')||
''||unistr('\000a')||
'      -- Default for l_theme: ''a-Icon'''||unistr('\000a')||
'      l_display_value := '||unistr('\000a')||
'         ''<span class="ddtl_display_block ddtl_clickable" id="'' || l_display_block_id || ''" title="'' || l_alt || ''">'''||unistr('\000a')||
'      ||   ''<span class="ddtl_imag'||
'e_'' || l_theme || '' '' || l_theme || '' '' || ''icon-tree-folder"></span>'''||unistr('\000a')||
'      ||   ''<span class="ddtl_text">'' || apex_plugin_util.escape ( p_value => l_value, p_escape => true ) || ''</span>'''||unistr('\000a')||
'      || ''</span>'';'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_display_value := '||unistr('\000a')||
'         ''<span class="ddtl_display_block ddtl_clickable" id="'' || l_display_block_id || ''" title="'' || l_alt || ''">'''||unistr('\000a')||
'      ||   ''<span class="ddtl_image_'''||
' || l_theme || ''"></span>'''||unistr('\000a')||
'      ||   ''<span class="ddtl_text">'' || apex_plugin_util.escape ( p_value => l_value, p_escape => true ) || ''</span>'''||unistr('\000a')||
'      || ''</span>'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  apex_plugin_util.print_display_only ('||unistr('\000a')||
'    p_item_name        => l_display_element_name,'||unistr('\000a')||
'    p_display_value    => l_display_value,'||unistr('\000a')||
'    p_show_line_breaks => false,'||unistr('\000a')||
'    p_escape           => false,'||unistr('\000a')||
'    p_attrib'||
'utes       => p_item.element_attributes );   '||unistr('\000a')||
''||unistr('\000a')||
'  return l_result;'||unistr('\000a')||
'end;'
 ,p_render_function => 'render_tree_list'
 ,p_standard_attributes => 'VISIBLE:SESSION_STATE:READONLY:QUICKPICK:SOURCE:ELEMENT'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_help_text => '<p>'||unistr('\000a')||
'	<strong>Drop Down Tree List Plug-in</strong></p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	First create a tree region, fill Static ID attribute. Then create <strong>Drop Down Tree List&nbsp;</strong>item plug-in, enter the same Tree Region Static ID.</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	That&#39;s all. You can customize appearance by using different themes, templates, region attributes.</p>'||unistr('\000a')||
''
 ,p_version_identifier => '2.0.2'
 ,p_about_url => 'https://github.com/ivyachmenev/Drop-Down-Tree-List'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 7593735921252107 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 100
 ,p_prompt => 'Tree Region Attributes'
 ,p_attribute_type => 'TEXTAREA'
 ,p_is_required => true
 ,p_default_value => 'max-height:800px; overflow:auto; position:absolute; display:none;'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 8661238078033687 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 110
 ,p_prompt => 'Width Auto-Sizing'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => '0'
 ,p_is_translatable => false
 ,p_help_text => 'If you have issues with tree region width you can turn this feature on.<br><br>'||unistr('\000a')||
''||unistr('\000a')||
'See documentation for more information.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 8661932471036248 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 8661238078033687 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Disabled'
 ,p_return_value => '0'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 8662330530037209 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 8661238078033687 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Enabled'
 ,p_return_value => '1'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 7539155763751698 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Tree Region Static ID'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_display_length => 16
 ,p_is_translatable => false
 ,p_help_text => 'Please specify Tree Region Static ID. <br />'||unistr('\000a')||
'The corresponding region will be used as source for Drop Down Tree List.<br /><br />'||unistr('\000a')||
'Note: Plug-in adds its own inline styles to the region (position:absolute, display:none, etc.). You don''t need to place them manually.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 7543245577348952 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Alt'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'Click to change the value.'
 ,p_display_length => 60
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 12772634254483444 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 15
 ,p_prompt => 'Page Item to Return Node Value'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => '1'
 ,p_is_translatable => false
 ,p_help_text => '<b>Derived From ''Selected Node Page Item'' Attribute of Tree Region</b> - this is the only option available. Filling ''Selected Node Page Item'' is necessory for animation to work properly. You can find this attribute on the <b>Tree Attributes</b> page. Item Value will be set after drop down list is selected. Unrestricted protection level must be used for this item or you will get item protection error.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 12774851279490781 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 12772634254483444 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Derived From ''Selected Node Page Item'' Attribute of Tree Region'
 ,p_return_value => '1'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 8668159351178575 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Expand Automatically'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'all'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 8672944458200689 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'n'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 8668856979179666 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 8668159351178575 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Yes'
 ,p_return_value => 'all'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 8669255254180502 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 8668159351178575 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'No'
 ,p_return_value => 'none'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 8672944458200689 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 40
 ,p_prompt => 'Hide Expand/Collapse Icons'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'y'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 8673642732201414 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 8672944458200689 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Yes'
 ,p_return_value => 'y'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 8674041654201925 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 8672944458200689 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'No'
 ,p_return_value => 'n'
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E204275696C64547265654C696E6B732820705472656549640D0A20202020202020202020202020202020202020202020202C20705472656553746174696349640D0A09090909202020202020202C2070446973706C6179426C6F636B';
wwv_flow_api.g_varchar2_table(2) := '49640D0A09090909092020202C207048696464656E456C656D656E7449640D0A0909090920200D0A09090909202020202020202C2070506167654974656D546F52657475726E0D0A0909090920200D0A09090909202020202020202C2070456E67696E65';
wwv_flow_api.g_varchar2_table(3) := '0D0A09090909092020202C20705468656D650D0A0909090920200D0A09090909202020202020202C207052656D6F766549636F6E730D0A09090909202020202020202C20704175746F457870616E640D0A09090909202020202020202C20704175746F53';
wwv_flow_api.g_varchar2_table(4) := '697A652029207B0D0A202020200D0A092F2F204150455820352E3020545245450D0A09696620282070456E67696E65203D3D2027415045585F54524545272029207B0D0A090D0A0909766172206C54726565417272203D20617065782E6A517565727928';
wwv_flow_api.g_varchar2_table(5) := '222322202B2070547265655374617469634964202B2022206C6922293B0D0A0909766172206C4F626A203D2077696E646F775B20226722202B20705472656549642E73756273747228302C31292E746F5570706572436173652829202B20705472656549';
wwv_flow_api.g_varchar2_table(6) := '642E737562737472283129202B20224461746122205D3B0D0A09090D0A090969662028206C4F626A2E646174612029206C4F626A203D206C4F626A2E646174613B0D0A09090D0A0909547265654F626A4C6F6F7028206C4F626A2C2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(7) := '28704F626A2C70496E646578297B0D0A0909090D0A090909766172206C4E6F64654964203D20704F626A2E69643B0D0A090909766172206C4E6F646554657874203D20704F626A2E6C6162656C3B0D0A0D0A0909096C547265654172722E65712870496E';
wwv_flow_api.g_varchar2_table(8) := '646578292E66696E642822613A666972737422292E61747472282268726566222C222322293B0D0A090909704F626A2E6C696E6B203D20274A6176615363726970743A2053656C656374547265654E6F6465322822272B70547265655374617469634964';
wwv_flow_api.g_varchar2_table(9) := '2B27222C22272B70506167654974656D546F52657475726E2B27222C22272B70446973706C6179426C6F636B49642B27222C22272B7048696464656E456C656D656E7449642B27222C22272B6C4E6F646549642B27222C22272B6C4E6F6465546578742B';
wwv_flow_api.g_varchar2_table(10) := '272220293B273B0D0A09097D293B0D0A092F2F204A5354524545202F20504C5547494E0D0A097D20656C7365207B0D0A0909617065782E6A517565727928222322202B2070547265655374617469634964202B2022206C6922292E65616368282066756E';
wwv_flow_api.g_varchar2_table(11) := '6374696F6E2829207B0D0A0D0A090909766172206C4E6F64654964203D20617065782E6A51756572792874686973292E617474722822696422293B0D0A090909766172206C4E6F6465546578743B0D0A0D0A0909092F2F2072656D6F7665206578747261';
wwv_flow_api.g_varchar2_table(12) := '20776869746573706163650D0A0909096C4E6F646554657874203D20617065782E6A51756572792E7472696D2820617065782E6A51756572792874686973292E6368696C6472656E28226122292E74657874282920293B0D0A0D0A0909092F2F20736574';
wwv_flow_api.g_varchar2_table(13) := '206C696E6B0D0A090909617065782E6A51756572792874686973292E6368696C6472656E28226122292E61747472282268726566222C274A6176615363726970743A2053656C656374547265654E6F64652822272B705472656553746174696349642B27';
wwv_flow_api.g_varchar2_table(14) := '222C22272B70506167654974656D546F52657475726E2B27222C22272B70446973706C6179426C6F636B49642B27222C22272B7048696464656E456C656D656E7449642B27222C22272B6C4E6F646549642B27222C22272B6C4E6F6465546578742B2722';
wwv_flow_api.g_varchar2_table(15) := '20293B27293B0D0A09097D293B0D0A097D0D0A7D0D0A0D0A66756E6374696F6E20547265654F626A4C6F6F70202820704F626A2C2063616C6C6261636B2029207B0D0A090D0A0969662028202177696E646F772E674444544C5F5374617274496E646578';
wwv_flow_api.g_varchar2_table(16) := '20292077696E646F772E674444544C5F5374617274496E646578203D20303B0D0A090D0A096966202820747970656F6628704F626A293D3D226F626A656374222029207B200D0A090D0A090963616C6C6261636B2E63616C6C286E756C6C2C704F626A2C';
wwv_flow_api.g_varchar2_table(17) := '674444544C5F5374617274496E646578293B0D0A09090D0A090969662028704F626A2E6368696C6472656E290D0A090909666F72202876617220693D303B693C704F626A2E6368696C6472656E2E6C656E6774683B692B2B29207B0D0A0909090D0A0909';
wwv_flow_api.g_varchar2_table(18) := '0909674444544C5F5374617274496E6465782B2B3B0D0A09090909547265654F626A4C6F6F702820704F626A2E6368696C6472656E5B695D2C2063616C6C6261636B20293B0D0A0909097D0D0A0909090D0A097D20656C7365206966202820747970656F';
wwv_flow_api.g_varchar2_table(19) := '6628704F626A293D3D226172726179222029207B0D0A0D0A0909666F72202876617220693D303B693C704F626A2E6C656E6774683B692B2B29207B0D0A0909090D0A090909674444544C5F5374617274496E6465782B2B3B0D0A090909547265654F626A';
wwv_flow_api.g_varchar2_table(20) := '4C6F6F702820704F626A5B695D2C2063616C6C6261636B20293B0D0A09097D0D0A097D0D0A7D0D0A0D0A66756E6374696F6E2053656C656374547265654E6F6465322820705472656553746174696349642C2070506167654974656D546F52657475726E';
wwv_flow_api.g_varchar2_table(21) := '2C2070446973706C6179426C6F636B49642C207048696464656E456C656D656E7449642C20704E6F646549642C20704E6F6465546578742029207B0D0A0D0A09617065782E6A517565727928222322202B2070446973706C6179426C6F636B4964202B20';
wwv_flow_api.g_varchar2_table(22) := '22202E6464746C5F7465787422292E7465787428704E6F646554657874293B200D0A09617065782E6A517565727928222322202B207054726565537461746963496420292E6869646528293B0D0A092473287048696464656E456C656D656E7449642C70';
wwv_flow_api.g_varchar2_table(23) := '4E6F646554657874293B0D0A090D0A092F2F207365742070616765206974656D20746F2072657475726E2069640D0A09696620282070506167654974656D546F52657475726E2029202024732870506167654974656D546F52657475726E2C20704E6F64';
wwv_flow_api.g_varchar2_table(24) := '654964293B0D0A7D0D0A0D0A66756E6374696F6E2053656C656374547265654E6F64652820705472656553746174696349642C2070506167654974656D546F52657475726E2C2070446973706C6179426C6F636B49642C207048696464656E456C656D65';
wwv_flow_api.g_varchar2_table(25) := '6E7449642C20704E6F646549642C20704E6F6465546578742029207B0D0A0D0A0D0A09617065782E6A517565727928222322202B2070547265655374617469634964202B2022202E636C69636B656422292E72656D6F7665436C6173732822636C69636B';
wwv_flow_api.g_varchar2_table(26) := '656422293B200D0A09617065782E6A517565727928222322202B2070547265655374617469634964202B2022202322202B20704E6F6465496420292E6368696C6472656E28226122292E616464436C6173732822636C69636B656422293B200D0A096170';
wwv_flow_api.g_varchar2_table(27) := '65782E6A517565727928222322202B2070446973706C6179426C6F636B4964202B2022202E6464746C5F7465787422292E7465787428704E6F646554657874293B200D0A09617065782E6A517565727928222322202B2070547265655374617469634964';
wwv_flow_api.g_varchar2_table(28) := '20292E6869646528293B200D0A092473287048696464656E456C656D656E7449642C704E6F646554657874293B0D0A090D0A092F2F207365742070616765206974656D20746F2072657475726E2069640D0A09696620282070506167654974656D546F52';
wwv_flow_api.g_varchar2_table(29) := '657475726E2029202024732870506167654974656D546F52657475726E2C20704E6F64654964293B0D0A7D0D0A0D0A66756E6374696F6E204669784F766572666C6F7748696464656E287054726565537461746963496429207B0D0A0D0A09617065782E';
wwv_flow_api.g_varchar2_table(30) := '6A517565727928222322202B2070547265655374617469634964292E706172656E747328292E63737328226F766572666C6F77222C2276697369626C6522293B0D0A7D0D0A0D0A66756E6374696F6E206464746C5F696E69742820705472656549640D0A';
wwv_flow_api.g_varchar2_table(31) := '2020202020202020202020202020202020202C20705472656553746174696349640D0A0909090920202C2070446973706C6179426C6F636B49640D0A0909090920202C207048696464656E456C656D656E7449640D0A0909090920200D0A090909092020';
wwv_flow_api.g_varchar2_table(32) := '2C2070506167654974656D546F52657475726E0D0A0909090920200D0A0909090920202C2070456E67696E650D0A0909090920202C20705468656D650D0A0909090920200D0A0909090920202C207052656D6F766549636F6E730D0A0909090920202C20';
wwv_flow_api.g_varchar2_table(33) := '704175746F457870616E640D0A0909090920202C20704175746F53697A652029207B0D0A090D0A090D0A092F2F20657870616E64206E6F6465730D0A0969662028207052656D6F766549636F6E73203D3D20277927207C7C20704175746F457870616E64';
wwv_flow_api.g_varchar2_table(34) := '203D3D2027616C6C272029207B0D0A0D0A090969662028207054726565496420292020617065782E7769646765742E747265652E657870616E645F616C6C2870547265654964293B0D0A097D0D0A09090D0A092F2F2072656D6F76652069636F6E730D0A';
wwv_flow_api.g_varchar2_table(35) := '0969662028207052656D6F766549636F6E73203D3D202779272029207B0D0A0D0A09096966202820705472656549642026262070456E67696E6520213D2027415045585F54524545272029207B0D0A090909090D0A0909096966202820617065782E6A51';
wwv_flow_api.g_varchar2_table(36) := '756572792E666E2E6F66662029207B0D0A0D0A09090909617065782E6A517565727928222322202B207054726565496420292E756E62696E6428292E6F666628293B200D0A0909097D20656C7365207B0D0A0D0A09090909617065782E6A517565727928';
wwv_flow_api.g_varchar2_table(37) := '222322202B207054726565496420292E756E62696E6428292E64696528293B200D0A0909097D0D0A09097D0D0A09090D0A0909696620282070456E67696E65203D3D2027415045585F54524545272029207B0D0A09090D0A090909617065782E6A517565';
wwv_flow_api.g_varchar2_table(38) := '727928222322202B2070547265654964202B2022202E612D54726565566965772D746F67676C652220292E72656D6F766528293B0D0A09097D20656C7365207B0D0A090909617065782E6A517565727928222322202B2070547265655374617469634964';
wwv_flow_api.g_varchar2_table(39) := '292E616464436C61737328226464746C5F7374617469635F22202B20705468656D6520293B0D0A09097D0D0A202020207D0D0A090D0A092F2F2073686F772064726F7020646F776E2074726565206C6973740D0A09617065782E6A517565727928222322';
wwv_flow_api.g_varchar2_table(40) := '202B2070446973706C6179426C6F636B4964292E636C69636B2866756E6374696F6E286576656E7429207B200D0A0D0A0909617065782E6A517565727928222322202B2070547265655374617469634964292E73686F7728293B200D0A0D0A0909696620';
wwv_flow_api.g_varchar2_table(41) := '2820704175746F53697A65203D3D20312029207B0D0A0D0A09090969662028617065782E6A517565727928222322202B2070547265655374617469634964202B2022206C693A666972737422292E6C656E677468203E203029200D0A090909090D0A0909';
wwv_flow_api.g_varchar2_table(42) := '0909617065782E6A517565727928222322202B2070547265655374617469634964292E63737328227769647468222C207061727365496E7428617065782E6A517565727928222322202B2070547265655374617469634964202B2022206C693A66697273';
wwv_flow_api.g_varchar2_table(43) := '7422292E637373282277696474682229292B34352B22707822293B200D0A090909656C73650D0A09090909617065782E6A517565727928222322202B2070547265655374617469634964292E63737328227769647468222C2022313030707822293B200D';
wwv_flow_api.g_varchar2_table(44) := '0A09097D0D0A0D0A0909617065782E6A517565727928222322202B2070547265655374617469634964292E706F736974696F6E287B6D793A226C65667420746F70222C2061743A22626F74746F6D222C206F663A222322202B2070446973706C6179426C';
wwv_flow_api.g_varchar2_table(45) := '6F636B4964202B2022202E6464746C5F696D6167655F22202B20705468656D652C20636F6C6C6973696F6E3A22666974227D293B0D0A09096576656E742E73746F7050726F7061676174696F6E28293B0D0A097D293B0D0A0D0A092F2F20686964652074';
wwv_flow_api.g_varchar2_table(46) := '72656520726567696F6E206F6E20636C69636B206F7574736964650D0A09617065782E6A517565727928646F63756D656E74292E636C69636B2866756E6374696F6E2829207B0D0A0D0A0909617065782E6A517565727928222322202B20705472656553';
wwv_flow_api.g_varchar2_table(47) := '74617469634964292E6869646528293B0D0A097D293B0D0A0D0A092F2F20546865206172656120696E73696465206F6620746865207472656520726567696F6E20616E64206F757473696465206F6620746865206C696E6B732073686F756C646E277420';
wwv_flow_api.g_varchar2_table(48) := '626520636C69636B61626C650D0A09617065782E6A517565727928222322202B2070547265655374617469634964292E636C69636B282066756E6374696F6E286576656E7429207B0D0A0D0A09096576656E742E73746F7050726F7061676174696F6E28';
wwv_flow_api.g_varchar2_table(49) := '293B0D0A097D293B0D0A0D0A0D0A092F2F204F766572726964652064656661756C742068616E646C657220666F722074726565206C696E6B730D0A094275696C64547265654C696E6B7328705472656549640D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(50) := '202C20705472656553746174696349640D0A09090909202C2070446973706C6179426C6F636B49640D0A09090909202C207048696464656E456C656D656E7449640D0A0909090920200D0A09090909202C2070506167654974656D546F52657475726E0D';
wwv_flow_api.g_varchar2_table(51) := '0A0909090920200D0A09090909202C2070456E67696E650D0A09090909202C20705468656D650D0A0909090920200D0A09090909202C207052656D6F766549636F6E730D0A09090909202C20704175746F457870616E640D0A09090909202C2070417574';
wwv_flow_api.g_varchar2_table(52) := '6F53697A65293B0D0A0D0A092F2F2053757270617373206F766572666C6F773A68696464656E20756E6976657273616C207468656D6520726567696F6E206C61796F75740D0A094669784F766572666C6F7748696464656E287054726565537461746963';
wwv_flow_api.g_varchar2_table(53) := '4964293B0D0A0D0A092F2F206275696C64206C696E6B730D0A09617065782E6A517565727928222322202B2070547265655374617469634964292E62696E64282261706578616674657272656672657368222C2066756E6374696F6E2829207B200D0A09';
wwv_flow_api.g_varchar2_table(54) := '0D0A09094275696C64547265654C696E6B7328705472656549640D0A0909090909202C20705472656553746174696349640D0A0909090909202C2070446973706C6179426C6F636B49640D0A0909090909202C207048696464656E456C656D656E744964';
wwv_flow_api.g_varchar2_table(55) := '0D0A0909090920200D0A0909090909202C2070506167654974656D546F52657475726E0D0A0909090920200D0A0909090909202C2070456E67696E650D0A0909090909202C20705468656D650D0A0909090920200D0A0909090909202C207052656D6F76';
wwv_flow_api.g_varchar2_table(56) := '6549636F6E730D0A0909090909202C20704175746F457870616E640D0A0909090909202C20704175746F53697A65293B200D0A097D293B0D0A090D0A092F2F204275672046697820666F72204170657820352E302E30202D20352E302E31202854797065';
wwv_flow_api.g_varchar2_table(57) := '4572726F723A20612E637572435353206973206E6F7420612066756E6374696F6E290D0A092F2F204170657820352E3020697320736869707065642077697468206A517565727920322E312E332074686174206973206E6F742066756C6C7920636F6D70';
wwv_flow_api.g_varchar2_table(58) := '617469626C65207769746820746865206F6C64206A7354726565206170657820696D706C656D656E746174696F6E0D0A09696620282021617065782E6A51756572792E6375724353532026262070456E67696E65203D3D20274A53545245452720292020';
wwv_flow_api.g_varchar2_table(59) := '617065782E6A51756572792E637572435353203D2066756E6374696F6E2028656C656D656E742C6174747269622C76616C29207B20617065782E6A517565727928656C656D656E74292E637373286174747269622C76616C293B207D0D0A7D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 3138700182423871 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_file_name => 'ddtl.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E204275696C64547265654C696E6B7328682C652C672C632C6C2C6B2C6A2C612C622C69297B6966286B3D3D22415045585F5452454522297B76617220663D617065782E6A5175657279282223222B652B22206C6922293B7661722064';
wwv_flow_api.g_varchar2_table(2) := '3D77696E646F775B2267222B682E73756273747228302C31292E746F55707065724361736528292B682E7375627374722831292B2244617461225D3B696628642E64617461297B643D642E646174617D547265654F626A4C6F6F7028642C66756E637469';
wwv_flow_api.g_varchar2_table(3) := '6F6E28702C6F297B766172206D3D702E69643B766172206E3D702E6C6162656C3B662E6571286F292E66696E642822613A666972737422292E61747472282268726566222C222322293B702E6C696E6B3D274A6176615363726970743A2053656C656374';
wwv_flow_api.g_varchar2_table(4) := '547265654E6F6465322822272B652B27222C22272B6C2B27222C22272B672B27222C22272B632B27222C22272B6D2B27222C22272B6E2B272220293B277D297D656C73657B617065782E6A5175657279282223222B652B22206C6922292E656163682866';
wwv_flow_api.g_varchar2_table(5) := '756E6374696F6E28297B766172206D3D617065782E6A51756572792874686973292E617474722822696422293B766172206E3B6E3D617065782E6A51756572792E7472696D28617065782E6A51756572792874686973292E6368696C6472656E28226122';
wwv_flow_api.g_varchar2_table(6) := '292E746578742829293B617065782E6A51756572792874686973292E6368696C6472656E28226122292E61747472282268726566222C274A6176615363726970743A2053656C656374547265654E6F64652822272B652B27222C22272B6C2B27222C2227';
wwv_flow_api.g_varchar2_table(7) := '2B672B27222C22272B632B27222C22272B6D2B27222C22272B6E2B272220293B27297D297D7D66756E6374696F6E20547265654F626A4C6F6F7028622C63297B6966282177696E646F772E674444544C5F5374617274496E646578297B77696E646F772E';
wwv_flow_api.g_varchar2_table(8) := '674444544C5F5374617274496E6465783D307D696628747970656F662862293D3D226F626A65637422297B632E63616C6C286E756C6C2C622C674444544C5F5374617274496E646578293B696628622E6368696C6472656E297B666F722876617220613D';
wwv_flow_api.g_varchar2_table(9) := '303B613C622E6368696C6472656E2E6C656E6774683B612B2B297B674444544C5F5374617274496E6465782B2B3B547265654F626A4C6F6F7028622E6368696C6472656E5B615D2C63297D7D7D656C73657B696628747970656F662862293D3D22617272';
wwv_flow_api.g_varchar2_table(10) := '617922297B666F722876617220613D303B613C622E6C656E6774683B612B2B297B674444544C5F5374617274496E6465782B2B3B547265654F626A4C6F6F7028625B615D2C63297D7D7D7D66756E6374696F6E2053656C656374547265654E6F64653228';
wwv_flow_api.g_varchar2_table(11) := '662C612C642C632C622C65297B617065782E6A5175657279282223222B642B22202E6464746C5F7465787422292E746578742865293B617065782E6A5175657279282223222B66292E6869646528293B247328632C65293B69662861297B247328612C62';
wwv_flow_api.g_varchar2_table(12) := '297D7D66756E6374696F6E2053656C656374547265654E6F646528662C612C642C632C622C65297B617065782E6A5175657279282223222B662B22202E636C69636B656422292E72656D6F7665436C6173732822636C69636B656422293B617065782E6A';
wwv_flow_api.g_varchar2_table(13) := '5175657279282223222B662B222023222B62292E6368696C6472656E28226122292E616464436C6173732822636C69636B656422293B617065782E6A5175657279282223222B642B22202E6464746C5F7465787422292E746578742865293B617065782E';
wwv_flow_api.g_varchar2_table(14) := '6A5175657279282223222B66292E6869646528293B247328632C65293B69662861297B247328612C62297D7D66756E6374696F6E204669784F766572666C6F7748696464656E2861297B617065782E6A5175657279282223222B61292E706172656E7473';
wwv_flow_api.g_varchar2_table(15) := '28292E63737328226F766572666C6F77222C2276697369626C6522297D66756E6374696F6E206464746C5F696E697428662C642C652C632C6A2C692C682C612C622C67297B696628613D3D2279227C7C623D3D22616C6C22297B69662866297B61706578';
wwv_flow_api.g_varchar2_table(16) := '2E7769646765742E747265652E657870616E645F616C6C2866297D7D696628613D3D227922297B69662866262669213D22415045585F5452454522297B696628617065782E6A51756572792E666E2E6F6666297B617065782E6A5175657279282223222B';
wwv_flow_api.g_varchar2_table(17) := '66292E756E62696E6428292E6F666628297D656C73657B617065782E6A5175657279282223222B66292E756E62696E6428292E64696528297D7D696628693D3D22415045585F5452454522297B617065782E6A5175657279282223222B662B22202E612D';
wwv_flow_api.g_varchar2_table(18) := '54726565566965772D746F67676C6522292E72656D6F766528297D656C73657B617065782E6A5175657279282223222B64292E616464436C61737328226464746C5F7374617469635F222B68297D7D617065782E6A5175657279282223222B65292E636C';
wwv_flow_api.g_varchar2_table(19) := '69636B2866756E6374696F6E286B297B617065782E6A5175657279282223222B64292E73686F7728293B696628673D3D31297B696628617065782E6A5175657279282223222B642B22206C693A666972737422292E6C656E6774683E30297B617065782E';
wwv_flow_api.g_varchar2_table(20) := '6A5175657279282223222B64292E63737328227769647468222C7061727365496E7428617065782E6A5175657279282223222B642B22206C693A666972737422292E637373282277696474682229292B34352B22707822297D656C73657B617065782E6A';
wwv_flow_api.g_varchar2_table(21) := '5175657279282223222B64292E63737328227769647468222C22313030707822297D7D617065782E6A5175657279282223222B64292E706F736974696F6E287B6D793A226C65667420746F70222C61743A22626F74746F6D222C6F663A2223222B652B22';
wwv_flow_api.g_varchar2_table(22) := '202E6464746C5F696D6167655F222B682C636F6C6C6973696F6E3A22666974227D293B6B2E73746F7050726F7061676174696F6E28297D293B617065782E6A517565727928646F63756D656E74292E636C69636B2866756E6374696F6E28297B61706578';
wwv_flow_api.g_varchar2_table(23) := '2E6A5175657279282223222B64292E6869646528297D293B617065782E6A5175657279282223222B64292E636C69636B2866756E6374696F6E286B297B6B2E73746F7050726F7061676174696F6E28297D293B4275696C64547265654C696E6B7328662C';
wwv_flow_api.g_varchar2_table(24) := '642C652C632C6A2C692C682C612C622C67293B4669784F766572666C6F7748696464656E2864293B617065782E6A5175657279282223222B64292E62696E64282261706578616674657272656672657368222C66756E6374696F6E28297B4275696C6454';
wwv_flow_api.g_varchar2_table(25) := '7265654C696E6B7328662C642C652C632C6A2C692C682C612C622C67297D293B69662821617065782E6A51756572792E6375724353532626693D3D224A535452454522297B617065782E6A51756572792E6375724353533D66756E6374696F6E286B2C6C';
wwv_flow_api.g_varchar2_table(26) := '2C6D297B617065782E6A5175657279286B292E637373286C2C6D297D7D7D3B';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 3139410397424838 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_file_name => 'ddtl.min.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D49484452000000500000004008060000008DC7F036000000097048597300000B1300000B1301009A9C1800000A4F6943435050686F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7DEF4424B';
wwv_flow_api.g_varchar2_table(2) := '8880944B6F5215082052428B801491262A2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E11E083C7C4C6E1E4';
wwv_flow_api.g_varchar2_table(3) := '2E40810A2470001008B3642173FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08801400407A8E42A600404601809D98265300A0040060CB6362E300502D0060277FE6D300809DF8997B01005B';
wwv_flow_api.g_varchar2_table(4) := '94211501A09100201365884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2573CF12BAE10E72A00007899B23CB9243945815B082D710757572E';
wwv_flow_api.g_varchar2_table(5) := '1E28CE49172B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F3';
wwv_flow_api.g_varchar2_table(6) := '70F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525D2FF64';
wwv_flow_api.g_varchar2_table(7) := 'E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C242';
wwv_flow_api.g_varchar2_table(8) := '10420A64801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F821C14804128B2420C9881451224B91354831528A542055481DF23D720239875C';
wwv_flow_api.g_varchar2_table(9) := '46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704128145C0';
wwv_flow_api.g_varchar2_table(10) := '093604774220611E4148584C584ED848A8201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9DA646BB20739942C';
wwv_flow_api.g_varchar2_table(11) := '202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11DD951E4E97D057D2CBE947E8';
wwv_flow_api.g_varchar2_table(12) := '97E803F4770C0D861583C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A9';
wwv_flow_api.g_varchar2_table(13) := '3BA887AA67A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344C';
wwv_flow_api.g_varchar2_table(14) := 'B931655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C';
wwv_flow_api.g_varchar2_table(15) := '2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2C';
wwv_flow_api.g_varchar2_table(16) := 'B6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A';
wwv_flow_api.g_varchar2_table(17) := 'DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5D13F0B9F';
wwv_flow_api.g_varchar2_table(18) := '95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B9';
wwv_flow_api.g_varchar2_table(19) := '4115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B';
wwv_flow_api.g_varchar2_table(20) := '1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC';
wwv_flow_api.g_varchar2_table(21) := '4C0D4CDD9B3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6';
wwv_flow_api.g_varchar2_table(22) := 'A5864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC';
wwv_flow_api.g_varchar2_table(23) := '94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566';
wwv_flow_api.g_varchar2_table(24) := 'D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B';
wwv_flow_api.g_varchar2_table(25) := '625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB9CBB9AAE';
wwv_flow_api.g_varchar2_table(26) := 'B95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43058F998FCB860D86';
wwv_flow_api.g_varchar2_table(27) := 'EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553D0A7FB93199393FF040398F3';
wwv_flow_api.g_varchar2_table(28) := 'FC63332DDB000000206348524D00007A25000080830000F9FF000080E9000075300000EA6000003A980000176F925FC54600000C6A4944415478DAEC9B7B9054D599C07FE7DEDBB7BB070686811986D788836C22C635C680B51A95B2D0AA0D5691641505';
wwv_flow_api.g_varchar2_table(29) := '041F315AEEF218A544D175815A5945028495DD65939240782D0886654589ECC618525658C528E1313EB6E5310C8C0EF3A01FF77DBFFDA3A73BC363047566C20C73AA6E7555DFDB7D6FFFFA3BF7FBCEEF9E8388F0E7DC2E9BFAB8FCB9AFE1AB5CB3413BB6';
wwv_flow_api.g_varchar2_table(30) := 'C766CF931123AEE248750DD535D594960CC03463ECDAF95F6CDBB655E58E1B3EED09F9E885E7149DB0194AE5AF3B3E73E9864C2680B81FC1351B5956797F01607DDE178848ABFB86550CE58DDFECA0E2924B79F887D3F8F1A2273999F6E855527EC6B139';
wwv_flow_api.g_varchar2_table(31) := '88C3A73D219D015CEE3A8D3CBC7F5E9F29BFBC82B8578C8E4D93294CFDC9C6CCB2CAF1E78438F9BE87CFFAA37D3FA0A1E9244307F5C7CA581CA9A967C82543D1C4E5DE8766C9CA7F7F3EFFEFE522B0334462CB1E9303589C6A6AC23B7192504FE3F81EA6';
wwv_flow_api.g_varchar2_table(32) := '6962274FF0D03FFD34A3A3705D17741D44231689B16CF69453C0AEFEF9BF9D7122D7F548A6D2FCCBB2E5781EF4EADD8BB52B9672FB84FB29307B713ABC4ED98581F8CC052BABC78D1B472412210C43745D275470EDD5D73483D3088200DBF30803083C8F';
wwv_flow_api.g_varchar2_table(33) := '505664FEF5C953BBB87EED7F9E718260D738003C0F0C5DCF1EA7EB8441D869E1B5BC660328765D17DBB649A55284618832744404C771504A1190EDA1BE0899B44D3C1AC5F77D8062E0E8B94E184A16A0A665CFAB00A16B340388FB118D1399249E97EDBA';
wwv_flow_api.g_varchar2_table(34) := '9EEB6318062121811F801766A3300C0924E4642A85699A00F1F339890864793737459769D97BA044C8A4BD6CB4F93E2242A005588E8DAEEBF82104E2A11B069E2F187A848C7FFE3124A19C0A902E06D0F5421C374029852F21BE9F8DC048C4246D59F802';
wwv_flow_api.g_varchar2_table(35) := 'B1588CA6B485A12BC250F0C2F0FC013677E196AD45F9D4F901DA61C867C924AE04A01B88A6D05C9FC04B61681102F1C172D07585EF3944237AFEBE78B68471B672C6F7219DCEE4DF8B448C2E14818181ED6B88A6E3BA82EFFBE8CA40850A4F05282D9B95';
wwv_flow_api.g_varchar2_table(36) := '43D727AA47713DB03D9D16258CBAFB47B35AEDD3FD7AC6705D385C7D8CC90F3E4E245644AFC29E5D076081A163373522BA910585601826A1E71304214AD7102D9B3B1D4294400FE3D4089AFF0F95677CF9A2E79E43B4A18C1A791FA6D987EFFDF5A32412';
wwv_flow_api.g_varchar2_table(37) := 'DB197DD3958CBF73629700A88041C04D773EB160ADEDB9081A21424437902044290D10BCC047298522A4201AE33F9E9D35097853445A2D63EEB8E32E193DFA49AAAB7721D4E2D883282BBB8937DFAC64D2947B9974D70F54570018072E03AE04FA9EE7E7';
wwv_flow_api.g_varchar2_table(38) := '4E007F043E1691568779BFDABE5D36FCF275448B128944E811373874F0130A0B8B1835F22AFEEEA17BBB04C05C3D577CBE755DF3E8A31EB03E4F265C14ADAD5DD922286E6DDF1C887536F777AE4D6BCB3F63FBB061336E9F3B77CF6B0306DC7DFABE9D83';
wwv_flow_api.g_varchar2_table(39) := '074F9EFEECB3BB7FD3A7CF6D9D21B0CACB077FE1AE159FB974833CBC78833CFAFCCB32F5272BE47CBA74EE9FD8128F4F3FFED863229B3649FDB265EEABA5A59372FB7E3D60C0A4CCBA75AE24129279E9A5E48EA2A2DBBA4A04AA537DE065A7F8C0C4DEFD';
wwv_flow_api.g_varchar2_table(40) := '9CCB078A082F29357584AEBFD0B7B090D8C89114DE7A2B49D3F47E3F7FFE3D3A70FDD34FAF2AB8E4920861080306601F3C98FEFDF4E9778D3E7EFC950B39020F1FAE3E67926B131F18C0156E10E0373662EDD8017FF8033DC78D8BDC386BD63ACD7589F9';
wwv_flow_api.g_varchar2_table(41) := '3E1C3A040505E038C47AF7EED1A3A8E87AE08205783EF0F265CCCC052B3367F38122D2AA0FDCB16307CD3ED0DE08437C58FC0DF89B1240074CA0E03BDFC1B8EE3A500A158940612161AF5EBCBB7CF9E64FDE7FFFD13B440E778508FC4A3E50448E2AA58E';
wwv_flow_api.g_varchar2_table(42) := '6C8447F7835C9185A87CC0FADDEF88D6D561DC7003BA69E27A9EBCBB7AF5E6237BF7CE1C0F472EE402E87C23B04D7CA0648BC1C3EB959A71C830BED62708AECCDF60ABAA10D7451F33868FF6ECD9F3C9DEBD332688D44827C8C2E703516BE9037D4F6165';
wwv_flow_api.g_varchar2_table(43) := '7C3C5B703201279B2C6C2B20E50A4D190FCB5758BE10B4E60323919BFBC76297BA227890DF9C440267E74ECACACB2B8ACACA6EEE0C65CCF946A0D6D2073A6E40CA76694A5B242D07A59BA42D97B4ED8232684A5BB84180EBF967F8C0754A4D1AA0D48B05';
wwv_flow_api.g_varchar2_table(44) := 'A9544FA7053CBFF93573E0003DDE7EBBF0DB63C7BEF8CAC081933A4B1DD8DA6B9BFAC0F5BA3EA148A99571D735ACE604A201BE69A2791E3D44F08160DF3E0AC2D0FCF6E8D12B5F2D2BF3BF7BFCF8860B3D025B7B6D531F2891C808555868B8F5F5846188';
wwv_flow_api.g_varchar2_table(45) := '06B8D1288734ED15CF75D5E530B62FE03B0E924840346A68867179B70FCCAA79B51196D7C110292EBEA77743032745381E049B34C799A5017BC1FA3ADC5E02D487211F5655ADB29B9A7ED6ED039B7DA0524AAD87C17E34FA4C8F787C8AD5D8F872041EC9';
wwv_flow_api.g_varchar2_table(46) := 'D5792F2955EEC092C1F08306A57EE188FCFD04A8962EA072DACC073647E2500F6E88C05BE3E1FF72809AF70DF3E0BA08EC1C0F07A58B78B036F581AAC5A3B6D3017DDEBE2EE5032F369FD7A63EB02BF9BC0E8FC08BD5E77DD50D1161234CDDABEB72ACA8';
wwv_flow_api.g_varchar2_table(47) := '481A6EB945FC850BA561E952F7B5D2D209AF97964E48BFF0822B5BB78A6CD922B26B97581B36A4DEE8DFFF0B432C7E64F0A8257B2ADFBBE6C7D73CD055001A1DE5F37A4C2BBD6AE98C1F6DBB7EF0CDFD86950CFB59C53F0EB7134F7FB4A6B3F7604D29A5';
wwv_flow_api.g_varchar2_table(48) := '7478B60A363734A765AFAE8EF48B2F12D9B28568632372FC38D4D6425D1D617D3DEF3CFEF8E6831F7C70CA8CCABE8F558CB967EBD85FC6EEEF5F71FA49FA560EBE76FEC3137FD5BF57BF7EEF1C7F8B8C6D5179FBD8D5BD1F19786B7BFCA879F3E6755896';
wwv_flow_api.g_varchar2_table(49) := '374444BEAACF8B3F34E8AF66FC70D4A6915FFB7AEFD2A2DE7FA1EE2E19236B3E3B06D0F36F07FFE59C07BFB7B5B090D203757B080385528A5D073E4C9C6C0C8EB5D70F9B376F9ECC9933A7DD9F3BAB9625D97AA506F6328CEDDF0C822B7511CCE6B19E59';
wwv_flow_api.g_varchar2_table(50) := '51416CCC18F61D39F2FE9ED75EFBEE04919ABCC17AA06CD4F7C797FC4FC5C07E3D6DCFA66FCF62AA0FCAFE9FAEF8DF5B7A17F5EC7FDFDDDFD86EC78F962633690CE981A945D957D5B0FFAD5F374C92B59FBED7DE11D8DE108D337C5E347AA99B4A61F0A7';
wwv_flow_api.g_varchar2_table(51) := '99A49248A076EEA4ECC61B2B0E677D5EFEDEE5BBBA7EA8B6D6F5CC5AFC20E08F754DF42EE83362E2A42B7E1B35F59E1FB8BF2DAD3B9184303BCDADBEDAFC38B1ABEFE4F682D7D191988FC0754A4D1A689A2B4A5DD7D49A959409449A9F71E840FC5BDF22';
wwv_flow_api.g_varchar2_table(52) := '79F5D5EEAE575FBDFFB69A9AB5F92F993268CCD091B5ABFA97070345B2D0E391087E10E07861161EF0E9E1E8FEEA77FA4D90F5D57BDA1BDAE9EFB51744ED349F675A2D4468C634492A95B5CA406ADF3E0A76EFCEF9BC3BF3B5E42F8EFEF7C15D650FD67C';
wwv_flow_api.g_varchar2_table(53) := '627CEA39E05AD0D8E4914A86B816380E1C4B443EAA7EB7FF94F68677B6D69E11A8E57D5EDFBE86AB69B8CDF092D1287B75FD95DD22DB3ECB963AD88E4326918044E20C9F276BAAB71D79A7647275C2A8756CB0D26065C0B6A12611AD3AB6A764BCAC3DB4';
wwv_flow_api.g_varchar2_table(54) := 'BB2BC1CB973111C7595E974CAE4A161713EA3A27358D8F8360536059D33598B61736D536DF0FEBC390B7ABAA56258F1E3DC3E7C99A9AD73F3B50FA40ED91486DE81B049EC1A787A21FD65795DC236B8FBED7D5E0E58772805A0F435647A3AB5E2E2A92B5';
wwv_flow_api.g_varchar2_table(55) := 'B0792394E7AAED8D50BE1A36BF01F2B252ABD6C390DCFDF3ACC39B8903C75CFEFCB013C3E70FFB988903BFD9D1A383B973E776D802C67C12694B9FA794524C1C701D0A4BD6D4BCDB955D82BAE87D5E5B02EC6E5F320B77B736188928A5E28B172FCE789E';
wwv_flow_api.g_varchar2_table(56) := '47341A259D4EF3D4534F157CDE1CE8EED60C5029155FB4685166E8D0A1141616128621B66DB370E1C28C52AA1BE2B9EE814AA94173E6CCA91E3E7C38BAAEE3BA2EA669B27FFF7E745D47D3345CD745D3349452C4623166CF9EDD0D96EC92FFF882050BCE';
wwv_flow_api.g_varchar2_table(57) := '582F2C228C1C3912D775B353DC8200D77511C9CE5C78E69967BAA39356E6076A9A76CAFCC0B079225118865896452C16FB42EB85DB4A8276C8C8E24B64E1B888D0D8D8484343039665D1D4D4442693C1F33C2CCBC2B66D1CC7C1B66D822020994C7EA1F5';
wwv_flow_api.g_varchar2_table(58) := 'C26D31ECBA10E1E5CB185DD7711C273FA53708023CCF23954AE1BA2E8EE390C964F07D1FCFCBAE2B765DB7C3C6AE172ABC3CC01C985CC4A5522932990C866160DB36B66DA3691AA9542A7F6C10041D22002E6478F932C6F33C1A1A1AF03C0F4DCBD6D69A';
wwv_flow_api.g_varchar2_table(59) := '969D586E18064110904AA5F2D938976CDAD3A274D4338D36012822044180A669F8BE9F5FB19E4B1CB9A4E2791E8661E48FEFF42AAAAD009AA6492A954229F5274DD35CBAE400E640E7CA9A582CD65D45D3627E606565E55AC771F2A07291969330B9E401';
wwv_flow_api.g_varchar2_table(60) := '108FC759B264C939D70B5F2C00DB6DBDF0C5023057CF75AF17FE12EDFF0700A5325731CB821A4D0000000049454E44AE426082';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 13863932507128940 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_file_name => 'apple_icons.png'
 ,p_mime_type => 'image/png'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D49484452000000500000004008060000008DC7F036000000097048597300000B1300000B1301009A9C1800000A4F6943435050686F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7DEF4424B';
wwv_flow_api.g_varchar2_table(2) := '8880944B6F5215082052428B801491262A2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E11E083C7C4C6E1E4';
wwv_flow_api.g_varchar2_table(3) := '2E40810A2470001008B3642173FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08801400407A8E42A600404601809D98265300A0040060CB6362E300502D0060277FE6D300809DF8997B01005B';
wwv_flow_api.g_varchar2_table(4) := '94211501A09100201365884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2573CF12BAE10E72A00007899B23CB9243945815B082D710757572E';
wwv_flow_api.g_varchar2_table(5) := '1E28CE49172B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F3';
wwv_flow_api.g_varchar2_table(6) := '70F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525D2FF64';
wwv_flow_api.g_varchar2_table(7) := 'E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C242';
wwv_flow_api.g_varchar2_table(8) := '10420A64801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F821C14804128B2420C9881451224B91354831528A542055481DF23D720239875C';
wwv_flow_api.g_varchar2_table(9) := '46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704128145C0';
wwv_flow_api.g_varchar2_table(10) := '093604774220611E4148584C584ED848A8201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9DA646BB20739942C';
wwv_flow_api.g_varchar2_table(11) := '202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11DD951E4E97D057D2CBE947E8';
wwv_flow_api.g_varchar2_table(12) := '97E803F4770C0D861583C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A9';
wwv_flow_api.g_varchar2_table(13) := '3BA887AA67A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344C';
wwv_flow_api.g_varchar2_table(14) := 'B931655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C';
wwv_flow_api.g_varchar2_table(15) := '2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2C';
wwv_flow_api.g_varchar2_table(16) := 'B6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A';
wwv_flow_api.g_varchar2_table(17) := 'DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5D13F0B9F';
wwv_flow_api.g_varchar2_table(18) := '95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B9';
wwv_flow_api.g_varchar2_table(19) := '4115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B';
wwv_flow_api.g_varchar2_table(20) := '1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC';
wwv_flow_api.g_varchar2_table(21) := '4C0D4CDD9B3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6';
wwv_flow_api.g_varchar2_table(22) := 'A5864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC';
wwv_flow_api.g_varchar2_table(23) := '94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566';
wwv_flow_api.g_varchar2_table(24) := 'D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B';
wwv_flow_api.g_varchar2_table(25) := '625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB9CBB9AAE';
wwv_flow_api.g_varchar2_table(26) := 'B95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43058F998FCB860D86';
wwv_flow_api.g_varchar2_table(27) := 'EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553D0A7FB93199393FF040398F3';
wwv_flow_api.g_varchar2_table(28) := 'FC63332DDB000000206348524D00007A25000080830000F9FF000080E9000075300000EA6000003A980000176F925FC54600000C414944415478DAEC9B797414451EC7BF353D47667287647207048124AC8B22E114E121C80ABC878B8A461284C5C0CA82';
wwv_flow_api.g_varchar2_table(29) := '89EC8AC7BA9B045CE589083C741123A21C22ACAC80A02CB0889C7224B0E148903098FB20217726D3D3DDBFFD633261AE2413C80089F9BD57AF27D3555D55DFF955D5AF3E5D0111E16EA6FBE7BF4677BB0DB7D366395C68AFBE914AD1D103915F508482A2';
wwv_flow_api.g_varchar2_table(30) := '02680382A154BAE1E4916FB167CF2E66CED777C1EB7465F552864E68720060CCD4F6336B07130010112449021161E8BCB3561D33E735E76BCDFAF4EE851F0EED47EF9EF7E1A5D90BF0FEF23751536F845740845D5EB3887D17BC4E9D4138733B9B3DF0CC';
wwv_flow_api.g_varchar2_table(31) := 'DAC1F4F09CD31659F603008EAC1C40A3922EB6EA1DF1B35E72D869411051595D835EA181D037E8915F7403E13D7B41463C66CE5D449FAF7DAFF9B9660FEC0C9E683962E466F1BC23462167EF537699832327E0E0B27E248A222449C29EC5E1904882288A';
wwv_flow_api.g_varchar2_table(32) := '00D0DCD98DEBD7D895E579236AEBEAF1D1871FC36804BCBCBDB0F9B355783AF60FD028BD602B5EA71DC24484FB7FF7418B991CDDDBFED700BBEFB8A13BEDBE134F4E0100188D809CE34CF9380E9228755AF12CDB2C07004992007C028073F211228C46A3';
wwv_flow_api.g_varchar2_table(33) := 'D3154A6412502633D5CB0010BA8659086812C6591304C1E9BC44805576862E63D6021A78E74AA994E639D0390125423BF4EE7C02368BA16F705AC09B5EEB9C07DA8E78CB70A8EB7860BD9302FAF83814D0BC60380A670401A8B778BE4221FF157BA0D5BC';
wwv_flow_api.g_varchar2_table(34) := '096C5CBF86C5252C6A715DF0F77003CF037905C5889FF31A146E3EF0F2F4E882023A3B073AD885FCE3EF497679962F5D0A92F5C2909859502A7DF1E4130BA1D3EDC598D10F60DAB3CF770901995988EF96449039409624D3D59CCC7F4B92D4FC79CEC752';
wwv_flow_api.g_varchar2_table(35) := '9B93D833CF3C4763C6BC898282932094C2D0188AA0A0D1F8F1C7244C9F3113D39F9BCABA8C80AEB0FFECDD4B5BBFD90792A9A05028E0AE9623F7976BF0F4F4C1909881F8D3DC99DD02FEDA4DD6D10FFC8031BF96EEA530E6D62D602BB6B74F9FC4A75352';
wwv_flow_api.g_varchar2_table(36) := '32BF0F0E8EB3BD77242C2CFEE577DF4D3FE4EB3BB9330813111146B73484D33F89699509B6C403776A342F0F9B3F7F55E0D0A1A82C2931FEB478F1AC274A4B3703C00F2121D3872D5FBE5E3D6C98429F9E5E772C2121765C65E56EDBC6B455778B9D7011';
wwv_flow_api.g_varchar2_table(37) := 'CF743A1C31A7336B0793A5F1468178A340875744B78ADDB701F32F701C15FBF850E5F8F1242C5B4695AB56F1DF6BB5B1FBB4DAD8FAD5AB79DAB58B68C70EA2932749BF756BDD0F8181931DD52D0902D5E87444B48F88F6D1E115D1B4D7DF5FFE99461374';
wwv_flow_api.g_varchar2_table(38) := 'D0DD1D070303EDEA378B676D37CBDBE675D477DB141E1EEAD4AB86660F4CFF24A609A8AE7320F36C1C5CD60FA268A230E670674A6A310380AF185BD31FF8634013CF51FBFBC363CA14F0515190F13CDCD46A402E07341AC0C303F0F6C6E9C4C4A531D9D9';
wwv_flow_api.g_varchar2_table(39) := '6F98EBF68E1805201775E9B5508B7D20045E83AAA73B809E28F9F600BC3CA350CC7E82A821BBFA2DCBDB5B4FE49DDF6D1D8ED994BFED40BA6D775E87B1AFBE0660B61D0F648CB16DC0BBD940801C782A0080B1BC1CF5EBD641F3C823908F1801AAAE0653';
wwv_flow_api.g_varchar2_table(40) := '28004F4F483C8F8C77DED9FECBE5CB6B622CEAEEF3F8FBC8DFB0017EDF7F8AF0A97D51D618094DAF0968BC7A1561A387C16DE040841C3D0AF5C891708F8CB4E2911DC5336DE7C0BCBC02E6B48037898CBE95EC1F36C10475330F2422628CE56F03165E02';
wwv_flow_api.g_varchar2_table(41) := '688049442600D01F3D0A557939E4A34681532AC11B8D94B171E3F6FC0B17FE3C0DC8278BBAF50D1FA17C5B1AFC8E9D474546067C274C40C38D22B86BBCE1E617009C3D0BFF9010541C5F0DF7C881563CD2153CD319F19A053C911642900327D242DA2C10';
wwv_flow_api.g_varchar2_table(42) := 'D67F28C2A3075BF14032B96FDE16C61273E5F2FEBEA2F8001199B05F763688E7C18D1B872B999999D72E5C488C252A229B7DB5C64385D0F7A622BFB21EB29F7490EDD8018FEC48281F7B0CA8AE03AF51A398BB02DF990FD8F14857F0CC767BE0F0849436';
wwv_flow_api.g_varchar2_table(43) := '7E4111570E9D47C1E5ED08D70E76CC03158AB1812AD57D7C5D1DE4B8499E49A7033B7204418F3EDA3B2F28682C804D8EC044605F7F78AC8F47D6A47FC24D771D75D9D970ABAA827AE244140637A2E7EB43205398DA6859BF2B78A6B31E681F071AF48E13';
wwv_flow_api.g_varchar2_table(44) := '38843F14DED4E0723B9CF52563D383195BA7A9ABF33000303625A1E9DA909505F7D3A73D074F9AB46E7748C874AB9FC68206551CCF81B2C6003D001E406349090C070EC0AD4A447D76513331B2ACDF8A2639936CCAB71607B674B5F2C0E10945EC445A08';
wwv_flow_api.g_varchar2_table(45) := '0D4F48691969E91BE0E613064EE98642DD79AB066CE1B8581FC63E57F3BC5C0F40D9F4CB084A25644623DC892000102F5E8446929483C78CF9FCBBA020616249C9D6E6CE1041F7E93114A6EC854F3D8F460022C7411245487979F0FAAF0655D58D109E0D';
wwv_flow_api.g_varchar2_table(46) := '82EFE44156F57714CF74E4812D5DED86F0CD87F7000AF35BA818F00AEA898AB27CAB06904211CD3C3DE5FC8D1B9024093200BC4A855C996CB791E7591430A90700C16000E974804A2597C9E551961E643008A83A950F81E468040F835C0E36390A426E05';
wwv_flow_api.g_varchar2_table(47) := '02CF16812E5F06E338E8A3243B016F976776C856CEE48529A689B825D7CF3987E0DF8C80BEB1AE39EC618C3185C1F071796DED17B57E7E90380E3532197244F16B51AF7F59062CB8007C5DDA341FDE90249CCECEFEA2B6B030CD5200959B02BDE73E048F';
wwv_flow_api.g_varchar2_table(48) := '9111A856ABA178320A0FBEF52806BC3D1EA5D15A943286FAD15EF07D2CCC2EECB2E299CEA48EDA85D86EE54EA485D0B5CB7576D1BA99035AA68435A2E5F68E6D01C20495EA6D77B57A86BEAAEADF0AE0956788F200E05F8C4518801561C0D44AC6361888';
wwv_flow_api.g_varchar2_table(49) := 'DE8A050AC8A272338FAC2BE7C1E90C30F69583539A02DE865201CA1201FCFD0C4CE69847BA8267DE519CD51450F73202A314C0F169C055B3404DF7FA1881110AE0C834E017EA221CAD437920B3D8A9DB0AD4DABD4E2FA045DF2CDDDAB69376F7BA616C37';
wwv_flow_api.g_varchar2_table(50) := '91BE6DB33A1F98929262C7D3962C59E25A9ED6D9CD2C424A4A8A154DCBC9C9A19C9C1C5AB468D12DF13447C9EF95B0212B3293CE3DFCFEC32F76B663BDADF2C0D4D454EAD7AF1FAAAAAA1C04ED3E387DFAB45D38208A22D2D2D29C0E05DC176807AE4A4C';
wwv_flow_api.g_varchar2_table(51) := '3830326CAC7F4E551612D356C5EBFE7665534739426A6A6A9BC321393999B9C403939393A9BD3673E64C2BCFF4FBCB7DE366EC9CF88D6A96B6B79DE725860E5D7131B16457E907B4E1DA62FAEADA7BB4EA52227925053FDE519E603B826CADE97E877B60';
wwv_flow_api.g_varchar2_table(52) := 'F3D998F4F474A70FFC1091154F53CF0D1D9E387BC8D731FD23BDB53EDEFD585CC038DA74BD18003CE685FD3679CE93BB3C3DA1CD2ACF84243230C67032EB675D4D9558ECB2D591B13B32475B1D2E6A4F85669EA6783168C8EFA705EC83A6CAE388EE107A';
wwv_flow_api.g_varchar2_table(53) := '04FB45CF7921E6008BF51FEFEDE3119810F7E05E9D744CFBBFDC7AC8C91D4A990A17B32B2F1D3F58399D36979DEF12ABB0594067CFFC711CD79C57E0392EB7B494372A4B218822CE9757C35BE31BFDFCF40187554ACEE3327F585B5E510B98800B6E1428';
wwv_flow_api.g_varchar2_table(54) := '7374277BC4D3E6B273AEF23CDBCFAEF444ABC345CE1EDBE538EEA6D76E283CC166843EDB2BA6F48BC008318408A8AD2F875A71A28FD028C2502B99C4035096A7BA5470C63F96B61464BA3AAAB82B43D85901DDDCDCAC71D686C2032C2E6C8E28967EE61F';
wwv_flow_api.g_varchar2_table(55) := '2C6825093034180132791D01A828545C29CE0C9C415B7233D185EC963CD0114FA34D057B585C487CE380EB1B7A040981A27073035851A4CABE71B9472C6DCE3D77A73A76A7827C2B01DB75EED941036953D13E3623F445C178FD53BF000A24022A8AB99F';
wwv_flow_api.g_varchar2_table(56) := 'ABAF06BC405FE6BB5CBCD4D4D4BBB7179E376F1ED906CAADF1B45DBB76B518F3B0E9A1E3A21E546F158CA8BC7251FF346D2E3C872E6A2E81098C3186E7834780414F9B8A32BA694CB7B568B26E09BA05BCFB618C23AAD11213ECE6810EC291968886D168';
wwv_flow_api.g_varchar2_table(57) := '24A3D168C704CDC27515A677DB3CD0EC79C9C9C9C8C8B05F34070D1A84850B17DE3C1F780B3CF09EE5791D35845B1B8E191919888B8BC3A041839ABF9B356B568737263939F99E0A92DB25A0796BD6DAB1AF53A74E990AC9E5EDDAF675F945242929899A';
wwv_flow_api.g_varchar2_table(58) := 'AE6D16888E8E46646464BBFE5FF857B10AC7C7C7B74AA489085959593873E60C222323DBB56F6EE72EE6AE81810E8903054170981863080F379D0FACAFAFEFB0D34DAD45058EDE04DE9302AE5CB9926DDCB8B1F95D87A3A4D7EBE1E7E707A552899C9C1C';
wwv_flow_api.g_varchar2_table(59) := '9709D8E90369B55A8D9A9A9A160B68B55A949494740B682BE0CA952B59525212C5C7C7B7B8C2969494203A3A1AFBF7EF77C9D0BA57439536698CF9FD41525212959595D9CD498ECE07EEDCB99375FB5F37CEEAA63177DBFE3F00FD8C9D0CE0335B450000';
wwv_flow_api.g_varchar2_table(60) := '000049454E44AE426082';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 13864631445130531 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_file_name => 'classic_icons.png'
 ,p_mime_type => 'image/png'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D49484452000000500000004008060000008DC7F036000000097048597300000B1300000B1301009A9C1800000A4F6943435050686F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7DEF4424B';
wwv_flow_api.g_varchar2_table(2) := '8880944B6F5215082052428B801491262A2109104A8821A1D91551C1114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE17BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E11E083C7C4C6E1E4';
wwv_flow_api.g_varchar2_table(3) := '2E40810A2470001008B3642173FD230100F87E3C3C2B22C007BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08801400407A8E42A600404601809D98265300A0040060CB6362E300502D0060277FE6D300809DF8997B01005B';
wwv_flow_api.g_varchar2_table(4) := '94211501A09100201365884400683B00ACCF568A450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00305188852900047B0060C8232378008499001446F2573CF12BAE10E72A00007899B23CB9243945815B082D710757572E';
wwv_flow_api.g_varchar2_table(5) := '1E28CE49172B14366102619A402EC27999193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEABF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225EE04685E0BA075F78B66B20F40B500A0E9DA57F3';
wwv_flow_api.g_varchar2_table(6) := '70F87E3C3C45A190B9D9D9E5E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9582A14E35112718E449A8CF332A52289429229C525D2FF64';
wwv_flow_api.g_varchar2_table(7) := 'E2DF2CFB033EDF3500B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D4280803806883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC708000044A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C242';
wwv_flow_api.g_varchar2_table(8) := '10420A64801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F821C14804128B2420C9881451224B91354831528A542055481DF23D720239875C';
wwv_flow_api.g_varchar2_table(9) := '46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD06474319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C46C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704128145C0';
wwv_flow_api.g_varchar2_table(10) := '093604774220611E4148584C584ED848A8201C243411DA093709038451C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C437241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9DA646BB20739942C';
wwv_flow_api.g_varchar2_table(11) := '202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11DD951E4E97D057D2CBE947E8';
wwv_flow_api.g_varchar2_table(12) := '97E803F4770C0D861583C7886728199B18071867197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353E3A909D496AB55AA9D50EB531B5367A9';
wwv_flow_api.g_varchar2_table(13) := '3BA887AA67A86F543FA47E59FD890659C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CDD97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C744E09E728A797F37E8ADE14EF29E2291BA6344C';
wwv_flow_api.g_varchar2_table(14) := 'B931655C6BAA96979658AB48AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE753D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C';
wwv_flow_api.g_varchar2_table(15) := '2406DB0CCE183CC535716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2C';
wwv_flow_api.g_varchar2_table(16) := 'B6A8B6B86549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D6167621767B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A';
wwv_flow_api.g_varchar2_table(17) := 'DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD347671767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F59D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5D13F0B9F';
wwv_flow_api.g_varchar2_table(18) := '95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF437F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65F6B2D9ED418CA0B9';
wwv_flow_api.g_varchar2_table(19) := '4115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE690E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3FC62E6659CCD5589D58496C4B';
wwv_flow_api.g_varchar2_table(20) := '1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA8168C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC91BC357924C533A52CE5B98427A990BC';
wwv_flow_api.g_varchar2_table(21) := '4C0D4CDD9B3A9E169A76206D323D3ABD31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6';
wwv_flow_api.g_varchar2_table(22) := 'A5864B572D1D58E6BDAC6A39B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC';
wwv_flow_api.g_varchar2_table(23) := '94B4A9ABC4B964CF66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB561D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566';
wwv_flow_api.g_varchar2_table(24) := 'D565FB49FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51DD23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B';
wwv_flow_api.g_varchar2_table(25) := '625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8BE73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB9CBB9AAE';
wwv_flow_api.g_varchar2_table(26) := 'B95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393DDDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43058F998FCB860D86';
wwv_flow_api.g_varchar2_table(27) := 'EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECBAE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C61EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553D0A7FB93199393FF040398F3';
wwv_flow_api.g_varchar2_table(28) := 'FC63332DDB000000206348524D00007A25000080830000F9FF000080E9000075300000EA6000003A980000176F925FC54600000F434944415478DAEC9B797495F599C73FBFBB6501128884040248C18C4B3BD6BAD78552B59E3A78C6521517C45D7B101D';
wwv_flow_api.g_varchar2_table(29) := '2D8E58079D714E8F47CFB89C7A466D3B88A2A222034A2B68ABD6055087111422282006219190186ED67BDFE5B73CF3C75D4802589C310C89FECE79CF7B73DFBBBDDF7C7FCFF3FC3EEFF32A11A1EBD8B266A110512082730E118B356176F3316180B321A3';
wwv_flow_api.g_varchar2_table(30) := 'C7564E2FAFBEF211FE8FA3FA865FC927FF7E8FA20F8DAEBF39D6F5C0A76B9E93B1DF1B0F64CF471C20A004C466FE560E71869717CC797862355F2AE02DB7FDAB1C71C4F7A9ABDF4EFDF67A86950F27912864E5F21759BAF48FAA2F8B981BDD0474D68208';
wwv_flow_api.g_varchar2_table(31) := 'C6F7414134AAD8BC7E05CE86581DE08CC6181FAB43CA8714B0F8B1EBE567573EB4D7131F37760C6FBCF92A630FFE0ED3AEBA81FBEEFF27DA539A92F2D17BFDAF56DFF02BE92B2EDC4D4071069C8FB521D16894CDEBDEA5FAA81F675C8845C4A17019372A';
wwv_flow_api.g_varchar2_table(32) := 'E185271F0260EA15D3F678D2C6585ADADA1953558197F6A8DB9E64D4C1638848C8E5BF9829737FFF6F79F1730EEC0B4EDCEB14B62644C422A241299CD5A004EBB7138965E262A81D648514E7F2EF7DEAF1DFEEF64561A8E9E84CF1F043BF436B28292DE1';
wwv_flow_api.g_varchar2_table(33) := 'E9C71EE4BC8BAEA43851424FF1FAC1140EC019C469C4288C09326EC3E10C88D88C1995C539DB4D4080E8097FD8ED0BECCA7300D01A62D168E675D128CEBA3E2B5ED7DFDC4D401DFA8041AC462211ACCE09984B223693609C0311AC33FBF4854E32024622';
wwv_flow_api.g_varchar2_table(34) := '99EF55D9A0D01F46F729AC039010A33D5016AB7D0407384CD081388B73F1ACA0663707EE6D8880E9AAB5A2DF8CEE0ED41E3ADD86359A685461B59F759E20C6C73987B14126FE89C3EDA303C5497701E98702AE5834434E396772FB8ECD5B4AA2F1223406';
wwv_flow_api.g_varchar2_table(35) := 'AD7D1416118B0E4300FC74322B2088ECBB03B5EEFE9C52FDC38631A55402D06FCDBF01D3D15812066954E8118DC298EAC359F1E26C4E3EFB2A822005E230610A9C20189CB37B4C187B2A678C81542A9D7F2E1E8FF51B079603D6398DF53DBC541BD1688C';
wwv_flow_api.g_varchar2_table(36) := '68344A2C91C059033842BF034408FC20BF4A714E72258CBAE49A997BCD0B4307161286B0ADBE81A9D7DE4ABC7030258306F61B011D50E59C21EC6CC14B75108BC788C4E21489C55A8342F053A94C0912C92DEFE8964BEFFAE79B76FBF0FBEFB907898CE1';
wwv_flow_api.g_varchar2_table(37) := 'F8E3AE209118C2CFCE9A416DED9F98F0A3BF65F20517F71B013B81B81347C120850BD3B47B8EA244615B675BDB5A67CD78C11189D85D828920085D41C4C1A346EC16D41A9A9A64C284ABF9F0C385088D047E15471F3D931797DC4449D970A65CF8F3BE2F';
wwv_flow_api.g_varchar2_table(38) := 'A0887428A5D6FE64EA6347CEBDAFB3265B29A350A5828CCF942C92352A38915D759C7C793577F55597F3DC0B73914801F1789C014575AC7CFFD7948F18476B5B7BBF70A012F9EB25EDE3F79E2BF9AC997FB970F92D8BFA5145F735D481005BD62ECACD53';
wwv_flow_api.g_varchar2_table(39) := '4404E70C274FF87B8C0EB0D9CD59CDA8B115D3F7F4810F2855364324B9A763772A5578A788DFAF141491FCB6F983F9227ABB38DD90D9C2CFC5E9CFC58575E2C2CFC405B5E2824FC4F91B64C993B748D7F78A082F8F1D7BE3D63BEFAC7FA9B2F2929EC796';
wwv_flow_api.g_varchar2_table(40) := '55554DDD79F7DDEBDF183CF8EC9EC70EC46DD4A82AD997D7F580090611C1047E76D1AFD8BC6E39CEE98CFB4C88350156870CEDC103FF505CFC0F275E7FFD6F2ABEF73D06DD7EFB632F5754C8598D8D4F03BC3162C49413EFBF7F4ED18927C64F38E49067';
wwv_flow_api.g_varchar2_table(41) := '5F1B32E4A2335A5A961CC8C6DAB6AD5E7DE5292CD620CEC79A9E3C3083F641B2AB900CA1593CEF6100FE53A9EB8F88461F94D9B3695DB3869233CF8CFF70D6ACC7FF5451E1A2C0C977DCF178D1C081716A6A281A3D7AE029BFFFFDFC372B2B2F9CB063C7';
wwv_flow_api.g_varchar2_table(42) := '012BE2E8D123655F44ECE1400D6200034A21D922DAF8ED44E3111087368064E02A599860E1BBA1B598D656BC575F850F3E60E039E7C4C7CF9CF94C240C293406B66E85E26208020A4B4B070C183CF86460495F7760A4FB922B409CC1D910311AAD7DC0A1';
wwv_flow_api.g_varchar2_table(43) := '94C3198333061183138DA071CEA1945251B87B032C6AC98216DDDC4C6ACE1CE28B1753D0DA8AECD8018D8DD0DC8C4B265975EBAD8B3EDBB8F1B707F2141E3D7AA47CE5296CB48F922C0F5411AC09F2F55FC675162443A6333CD02222A294AA5B00333E02';
wwv_flow_api.g_varchar2_table(44) := 'F92E9C5B0ECA00DE8A15143437133BF554A28904A1D6F2FE534F2DAA5BB7EEE6C95027FD200646BAF3401FD0E8308DB55E860766E3DDCEF0633E67250DE12AACE763FD74769D0C2222E78B6C7370E3D6586C9D510A9D0904041B36A0FFF217D09A4F6A6A';
wwv_flow_api.g_varchar2_table(45) := '6AB6AC5B77E3F922DB645F0AD03EE0C0484F07EA745BE62A9C0930A18788E653B38C604019F1F891F8C5056C8ABC463A6C467AD018E2F1D32A0A0BBF138AA021BF05B5B504CB9753397AF4D8C19595A7F585F2EE2B3B70C5F337CB093F3DBBBD25D98835';
wwv_flow_api.g_varchar2_table(46) := '1E264C634CC0FACE3FD02A0DD4A55EA1AA683C0DE965246507EBDC1BB85898FFA067949A325CA939C59D9D03832EE299EC3EFDF1C70C78EFBD41C74E9C3867C98811530E7401730EDCDB3E2FA0522AA19452CE684C476349E0A7F1532DA43B7650525DC2';
wwv_flow_api.g_varchar2_table(47) := 'A7ED2BD9DAFA0A75A905007C915E4D43FBBB7C1136110ECF2C389E8D462F1AACD4DCA2304C785D844B27127464A7730074AE5F4FF1EAD58963274C98FB5265E5057DC1817BDBEFCE03ADC6F91E7E9607462211EA0B36D2D0BA9EEB7EB039FF86C907D700';
wwv_flow_api.g_varchar2_table(48) := 'F09B95A349C40EC9C4C078FC083568502C4C2671CE1101C28202B646224B7418AAC361E241800902A4B6160A0A629158ECF0FEC503AD21E84892EE6C279E881389C528B2A56CDBB985DB7644314EB877A2E1F63FC70943080261787A304A29B5007ED70C';
wwv_flow_api.g_varchar2_table(49) := 'A3A4ACECB2D29616DA45D861EDC24810CC8C00EBC03B0CCE2B0792CEB169C38627FCB6B6D9FD8B07E228285188F669F753141514B5159A816BCB74F5F8BA6033361B32DBDB051D42597125435BC62052234AA9EDCF06C11D4950C1A041977AADADCFC79D';
wwv_flow_api.g_varchar2_table(50) := 'BBF97C916DD995CACD1F416424FCBC25957A3210B9E322D8DE1F2E6D2A11412955041CF2F8BDE7D7A8FCB55B955917C702ECB142CD676FD3E9B750181BC04103CA396FC405AC59B1892B662E5440CE8963349C1A877726C3A7B952257B6C9C8693E2B07C';
wwv_flow_api.g_varchar2_table(51) := '327C76A097315F2B0F9C73FF24D959DA402A2224AC50DE59415CC7B962E6F3DD02AAEA72A9ADA7405F76AC9FF1C085020AA5C0B9CCB5DF53C74FCAF2403F43634CA63F700F684CBE049BF51BD1F6EAC05C7FA04265C1B3ECEA1124DB1F48A6C563E98247';
wwv_flow_api.g_varchar2_table(52) := '397BEABDDF12E96E2EC9AE2CB4E7EDEA0FCCF14013E07497FEC0C17FBD3FF01B27A0331AB11ED686442211367FFC5F54FFE0C759786011F6DC1FB8AFE3A019A38EBFE38AF3FE63DE2BCB1F5A75F3AA47FB9F805667A98B464512191E280E1BB413894600';
wwv_flow_api.g_varchar2_table(53) := '411BC9F3C07D6D2E021870C3B0EF3F78E3354B4F1E79DAD071E5E3668FFD75B55F7BC727F3FABA807BE0813ADB1FB88B0782E0ACCD38D4EDE2815D7B630EBA65EC1997FD71E20B8557568CDDCD79378D3CE1AE6917FFB9A264E8D0553BDE21ED7BDC74DE';
wwv_flow_api.g_varchar2_table(54) := 'C4A74A7F39E2CCDE38A9679E7946FE5F1C68B49F21D22ECB0373FD81E2B2625932E9591027589B899945BFA8FAE18D571DBFF0B8430F2B1D36B8F46FD425E567C8BC2F1A00065E37F2C87FB9F6677F1C3488611F37D7E0AC4229C5CA8F37D5B6B7DA86DE';
wwv_flow_api.g_varchar2_table(55) := '3AB1F9F3E7CB85175EA8F6AB8056FB2865088334F1028B35018243106CD80162B136D71F681167895F5D79FCA4C9E5AF50DC3A7079ED9B1C34BCEC886B2F3BEE3575D1D09F940E1E5871CD2547FDA9D6BD3D6CEDD6143119402252C0FA0D2D1FBDF37ACB';
wwv_flow_api.g_varchar2_table(56) := '1479BAE9C3DE3AB1D34F3F9DB973E7CAE5975FAEF6A3030374AA156B3551A3303A8D128B22DB1F681D56824CEC138773161346A35B1B1B439D68C458CB87CD6D94160F39E2E229DF5D5690880EDC182E1BD6BCB303324DAD24EB139B6B571E34559E6E5A';
wwv_flow_api.g_varchar2_table(57) := 'D39B273664C810264E9CC8238F3C22D75D779DEAF518B862D10C39E1A77FD79EDCB903B13E264C61748064EB3F1D8618A3F13A9B08D24DF8E9E64C43FA939FBFFBDFAFC62F58F36172FB179D493A5396FA2F9AA957EF8EDBE8BF55D194ECC0056035ECA8';
wwv_flow_api.g_varchar2_table(58) := '2DF8A8F69DF27365DEF6F77BBDC0558AB2B232264D9AC45D77DDD56B31B10B0F34988EC6121D78F8A9245E472363AA0FE7ED171F255A5040BA3549F3EB1F11A91B8A6C194C72D9265CB6ED549EFCFCB5CF56565EBB7D4BAC4907107AD0DAA6E9EC70841E';
wwv_flow_api.g_varchar2_table(59) := '040134D4C63FA97FBFE25279B6BE667F04771121994CB278F16266CD9AD5AB0E2C072AACD338DFC74BB5E1A5DA097C0FE734CE6A442C4D7F59CFA0C448F4275B709F355036E070066CDB45A4655EFDD2BA55E553EB6B638D810F5E0ABC34F83E6CAF2DD8';
wwv_flow_api.g_varchar2_table(60) := 'D050533E599EDEBA7A7F65C76432C9D2A54B99366D5AAFC7C06E3CD04B6578A0363190E2EC8523416DED60D82F2FC9BFB1E9F94554B626BAFFD7E76D7F455D5A75B5D15F3C5A562E1522B0B321BAA9EDD3F2CBE499BA35FB4B3C11E1F5D75FA7B7134837';
wwv_flow_api.g_varchar2_table(61) := '1E28591EE8B44FABD7497141515B675BFB5A6BCD78C4D1F4D242D6450B29187D3020A4D7AEA1F1AD9776FFF14F7EBE444DA9BAA4B2A8E839A36969ABF52ED89FE2E5E2DFFE2861F6C00327D7A85C5A11855299069A4BA7DFCACBFF388BE8FC5776DD8708';
wwv_flow_api.g_varchar2_table(62) := '6C39E368A63DBB4AEDE10414170F3F0985B73F12C601CF03E7DE779E8875F8EF6E66C07B1B71D128E9930EE3BAF9EF7FE369CC6E02BEFDF6DBA294CAF606BACCBD21C6A0B5466B4D18861863A8AAAA9A7ECA29A73CF2AD805D045CBE7CB91C75D451DD82';
wwv_flow_api.g_varchar2_table(63) := '716EDF75B3D6B260C102A64F9FFE2D0FECB694B316114167EF8A894422AC59B326EF40634CDE812525253CF0C0033263C68C6F79601E677599AED16894B56BD772CC31C7E49DE7B2F82AB77FE28927F8D6815D86D69996356B2D91480463321DABBEEFE7';
wwv_flow_api.g_varchar2_table(64) := '6FCDCA3DD7758A7F93470F1E68F2025A6BD15A77735F4EBCDC63F71580EAFF761C7AE8A1D2671C1804413707E61CD955C4DCE35CCCEC6DF10E7497477A4E616B2D41101004016118E605F33C0FCFF308C390300CF362F7A678C71C73CC017F57E76E0E4C';
wwv_flow_api.g_varchar2_table(65) := 'A7D368ADBB39B0EBF4EEEAC2DE72604EBC3E954466CF9E2D679D75567B5D5D5D49229140440882203F75C3ECFDC21D1D1DBD9A44FA9278DD78A0B596F6F6F612DFF7E9E8E8A0B5B595EAEA6A162F5E4C3C1EC7F33CD2E934BEEFE79DFA753B3017F356AF';
wwv_flow_api.g_varchar2_table(66) := '5E9DDFFA8203CB019B2B923B3B3B89C532F70BC7E3F17C71ED795EDE955D57275FE7D8B871639F2BCAF33CD05A4B2A9522954A118BC588C56214161662B2D4399D4EEF868CBEAD03335938D31FE81CB1588C300C696B6B239D4EB73535352DB3D6E61349';
wwv_flow_api.g_varchar2_table(67) := 'D7D8974B26DFF89548EE7EE11933661C396BD6AC9A2C1F4429552A22E37B268CFD513CF7699CB5A771DB6DB749CF7A4C44B8FBEEBBBFF134E67F0600658CD3FAE0A8FD540000000049454E44AE426082';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 13865341235132122 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_file_name => 'default_icons.png'
 ,p_mime_type => 'image/png'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E6464746C5F696D6167655F64656661756C74207B20646973706C61793A20696E6C696E652D626C6F636B3B206865696768743A313670783B2077696474683A313670783B206261636B67726F756E643A75726C282723504C5547494E5F505245464958';
wwv_flow_api.g_varchar2_table(2) := '2364656661756C745F69636F6E732E706E672729206E6F2D7265706561743B20646973706C61793A696E6C696E652D626C6F636B3B20666C6F61743A6C656674207D0D0A2E6464746C5F696D6167655F636C6173736963207B20646973706C61793A2069';
wwv_flow_api.g_varchar2_table(3) := '6E6C696E652D626C6F636B3B206865696768743A313670783B2077696474683A313670783B206261636B67726F756E643A75726C282723504C5547494E5F50524546495823636C61737369635F69636F6E732E706E672729206E6F2D7265706561743B20';
wwv_flow_api.g_varchar2_table(4) := '646973706C61793A696E6C696E652D626C6F636B3B20666C6F61743A6C656674207D0D0A2E6464746C5F696D6167655F6170706C65207B20646973706C61793A20696E6C696E652D626C6F636B3B206865696768743A313670783B2077696474683A3136';
wwv_flow_api.g_varchar2_table(5) := '70783B206261636B67726F756E643A75726C282723504C5547494E5F505245464958236170706C655F69636F6E732E706E672729206E6F2D7265706561743B20646973706C61793A696E6C696E652D626C6F636B3B20666C6F61743A6C656674207D0D0A';
wwv_flow_api.g_varchar2_table(6) := '2E6464746C5F696D6167655F612D49636F6E207B20646973706C61793A20696E6C696E652D626C6F636B3B206865696768743A313670783B2077696474683A313670783B20646973706C61793A696E6C696E652D626C6F636B3B20666C6F61743A6C6566';
wwv_flow_api.g_varchar2_table(7) := '74207D0D0A0D0A2E6464746C5F7374617469635F64656661756C74202E6F70656E207B206261636B67726F756E643A2075726C282723504C5547494E5F5052454649582364656661756C745F69636F6E732E706E672729206E6F2D726570656174202D36';
wwv_flow_api.g_varchar2_table(8) := '347078202D3136707820202120696D706F7274616E743B207D0D0A2E6464746C5F7374617469635F636C6173736963202E6F70656E207B206261636B67726F756E643A2075726C282723504C5547494E5F50524546495823636C61737369635F69636F6E';
wwv_flow_api.g_varchar2_table(9) := '732E706E672729206E6F2D726570656174202D36347078202D3136707820202120696D706F7274616E743B207D0D0A2E6464746C5F7374617469635F6170706C65202E6F70656E207B206261636B67726F756E643A2075726C282723504C5547494E5F50';
wwv_flow_api.g_varchar2_table(10) := '5245464958236170706C655F69636F6E732E706E672729206E6F2D726570656174202D36347078202D3136707820202120696D706F7274616E743B207D0D0A0D0A2E6464746C5F646973706C61795F626C6F636B207B7D0D0A2E6464746C5F636C69636B';
wwv_flow_api.g_varchar2_table(11) := '61626C65207B20637572736F723A20706F696E746572207D0D0A2E6464746C5F726561646F6E6C79207B20637572736F723A2064656661756C74207D0D0A0D0A2E6464746C5F7465787420207B206D617267696E2D6C6566743A3170783B20646973706C';
wwv_flow_api.g_varchar2_table(12) := '61793A696E6C696E653B20666F6E742D7765696768743A6E6F726D616C207D0D0A2E6464746C5F636C69636B61626C65202E6464746C5F746578743A686F766572207B20746578742D6465636F726174696F6E3A756E6465726C696E65207D0D0A0D0A2F';
wwv_flow_api.g_varchar2_table(13) := '2A204275672046697820666F7220352E302E312E30302E3036202D206D697373696E67207472656520666F6C6465722069636F6E202A2F0D0A2F2A206C696E65203836362C202E2E2F736373732F636F72652F49636F6E466F6E742E73637373202A2F0D';
wwv_flow_api.g_varchar2_table(14) := '0A2E612D49636F6E2E69636F6E2D747265652D666F6C6465723A6265666F72652C0D0A2E612D54726565566965772D6E6F64652E69732D657870616E6461626C65203E202E612D54726565566965772D636F6E74656E74203E202E612D49636F6E2E6963';
wwv_flow_api.g_varchar2_table(15) := '6F6E2D747265652D666F6C6465723A6265666F7265207B0D0A2020636F6E74656E743A20225C65306461223B0D0A7D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 13906543031203504 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_file_name => 'ddtl.css'
 ,p_mime_type => 'text/css'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E6464746C5F696D6167655F64656661756C747B646973706C61793A696E6C696E652D626C6F636B3B6865696768743A313670783B77696474683A313670783B6261636B67726F756E643A75726C282723504C5547494E5F505245464958236465666175';
wwv_flow_api.g_varchar2_table(2) := '6C745F69636F6E732E706E672729206E6F2D7265706561743B646973706C61793A696E6C696E652D626C6F636B3B666C6F61743A6C6566747D2E6464746C5F696D6167655F636C61737369637B646973706C61793A696E6C696E652D626C6F636B3B6865';
wwv_flow_api.g_varchar2_table(3) := '696768743A313670783B77696474683A313670783B6261636B67726F756E643A75726C282723504C5547494E5F50524546495823636C61737369635F69636F6E732E706E672729206E6F2D7265706561743B646973706C61793A696E6C696E652D626C6F';
wwv_flow_api.g_varchar2_table(4) := '636B3B666C6F61743A6C6566747D2E6464746C5F696D6167655F6170706C657B646973706C61793A696E6C696E652D626C6F636B3B6865696768743A313670783B77696474683A313670783B6261636B67726F756E643A75726C282723504C5547494E5F';
wwv_flow_api.g_varchar2_table(5) := '505245464958236170706C655F69636F6E732E706E672729206E6F2D7265706561743B646973706C61793A696E6C696E652D626C6F636B3B666C6F61743A6C6566747D2E6464746C5F696D6167655F612D49636F6E7B646973706C61793A696E6C696E65';
wwv_flow_api.g_varchar2_table(6) := '2D626C6F636B3B6865696768743A313670783B77696474683A313670783B646973706C61793A696E6C696E652D626C6F636B3B666C6F61743A6C6566747D2E6464746C5F7374617469635F64656661756C74202E6F70656E7B6261636B67726F756E643A';
wwv_flow_api.g_varchar2_table(7) := '75726C282723504C5547494E5F5052454649582364656661756C745F69636F6E732E706E672729206E6F2D726570656174202D36347078202D3136707821696D706F7274616E747D2E6464746C5F7374617469635F636C6173736963202E6F70656E7B62';
wwv_flow_api.g_varchar2_table(8) := '61636B67726F756E643A75726C282723504C5547494E5F50524546495823636C61737369635F69636F6E732E706E672729206E6F2D726570656174202D36347078202D3136707821696D706F7274616E747D2E6464746C5F7374617469635F6170706C65';
wwv_flow_api.g_varchar2_table(9) := '202E6F70656E7B6261636B67726F756E643A75726C282723504C5547494E5F505245464958236170706C655F69636F6E732E706E672729206E6F2D726570656174202D36347078202D3136707821696D706F7274616E747D2E6464746C5F636C69636B61';
wwv_flow_api.g_varchar2_table(10) := '626C657B637572736F723A706F696E7465727D2E6464746C5F726561646F6E6C797B637572736F723A64656661756C747D2E6464746C5F746578747B6D617267696E2D6C6566743A3170783B646973706C61793A696E6C696E653B666F6E742D77656967';
wwv_flow_api.g_varchar2_table(11) := '68743A6E6F726D616C7D2E6464746C5F636C69636B61626C65202E6464746C5F746578743A686F7665727B746578742D6465636F726174696F6E3A756E6465726C696E657D2E612D49636F6E2E69636F6E2D747265652D666F6C6465723A6265666F7265';
wwv_flow_api.g_varchar2_table(12) := '2C2E612D54726565566965772D6E6F64652E69732D657870616E6461626C653E2E612D54726565566965772D636F6E74656E743E2E612D49636F6E2E69636F6E2D747265652D666F6C6465723A6265666F72657B636F6E74656E743A225C65306461227D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 14069130731475565 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 7423044384497850 + wwv_flow_api.g_id_offset
 ,p_file_name => 'ddtl.min.css'
 ,p_mime_type => 'text/css'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
