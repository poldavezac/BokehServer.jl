#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iStyles, Bokeh.Models.CustomJS

@model mutable struct Styles <: iStyles

    background_color :: Bokeh.Model.Nullable{String} = nothing

    mask_composite :: Bokeh.Model.Nullable{String} = nothing

    alignment_baseline :: Bokeh.Model.Nullable{String} = nothing

    font_stretch :: Bokeh.Model.Nullable{String} = nothing

    overflow_y :: Bokeh.Model.Nullable{String} = nothing

    padding_right :: Bokeh.Model.Nullable{String} = nothing

    row_gap :: Bokeh.Model.Nullable{String} = nothing

    overscroll_behavior_inline :: Bokeh.Model.Nullable{String} = nothing

    background_attachment :: Bokeh.Model.Nullable{String} = nothing

    transition_delay :: Bokeh.Model.Nullable{String} = nothing

    border_color :: Bokeh.Model.Nullable{String} = nothing

    column_rule :: Bokeh.Model.Nullable{String} = nothing

    border_width :: Bokeh.Model.Nullable{String} = nothing

    mask :: Bokeh.Model.Nullable{String} = nothing

    border_block_end_color :: Bokeh.Model.Nullable{String} = nothing

    clip_rule :: Bokeh.Model.Nullable{String} = nothing

    text_decoration_style :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    flood_color :: Bokeh.Model.Nullable{String} = nothing

    overflow :: Bokeh.Model.Nullable{String} = nothing

    marker_end :: Bokeh.Model.Nullable{String} = nothing

    border_spacing :: Bokeh.Model.Nullable{String} = nothing

    min_inline_size :: Bokeh.Model.Nullable{String} = nothing

    object_position :: Bokeh.Model.Nullable{String} = nothing

    right :: Bokeh.Model.Nullable{String} = nothing

    border_block_start_width :: Bokeh.Model.Nullable{String} = nothing

    background_position_x :: Bokeh.Model.Nullable{String} = nothing

    font_size :: Bokeh.Model.Nullable{String} = nothing

    color :: Bokeh.Model.Nullable{String} = nothing

    grid_row_end :: Bokeh.Model.Nullable{String} = nothing

    bottom :: Bokeh.Model.Nullable{String} = nothing

    font_variant_ligatures :: Bokeh.Model.Nullable{String} = nothing

    mask_position :: Bokeh.Model.Nullable{String} = nothing

    backface_visibility :: Bokeh.Model.Nullable{String} = nothing

    text_indent :: Bokeh.Model.Nullable{String} = nothing

    min_block_size :: Bokeh.Model.Nullable{String} = nothing

    font_weight :: Bokeh.Model.Nullable{String} = nothing

    font_style :: Bokeh.Model.Nullable{String} = nothing

    css_float :: Bokeh.Model.Nullable{String} = nothing

    text_decoration :: Bokeh.Model.Nullable{String} = nothing

    text_underline_position :: Bokeh.Model.Nullable{String} = nothing

    border_inline_end_style :: Bokeh.Model.Nullable{String} = nothing

    justify_items :: Bokeh.Model.Nullable{String} = nothing

    page_break_before :: Bokeh.Model.Nullable{String} = nothing

    border_right_width :: Bokeh.Model.Nullable{String} = nothing

    text_decoration_line :: Bokeh.Model.Nullable{String} = nothing

    ruby_align :: Bokeh.Model.Nullable{String} = nothing

    background_image :: Bokeh.Model.Nullable{String} = nothing

    paint_order :: Bokeh.Model.Nullable{String} = nothing

    align_items :: Bokeh.Model.Nullable{String} = nothing

    grid_auto_rows :: Bokeh.Model.Nullable{String} = nothing

    flex_grow :: Bokeh.Model.Nullable{String} = nothing

    css_text :: Bokeh.Model.Nullable{String} = nothing

    vertical_align :: Bokeh.Model.Nullable{String} = nothing

    justify_content :: Bokeh.Model.Nullable{String} = nothing

    border_inline_start_color :: Bokeh.Model.Nullable{String} = nothing

    outline :: Bokeh.Model.Nullable{String} = nothing

    border_image :: Bokeh.Model.Nullable{String} = nothing

    widows :: Bokeh.Model.Nullable{String} = nothing

    stroke_width :: Bokeh.Model.Nullable{String} = nothing

    margin_right :: Bokeh.Model.Nullable{String} = nothing

    top :: Bokeh.Model.Nullable{String} = nothing

    fill_rule :: Bokeh.Model.Nullable{String} = nothing

    grid_row_gap :: Bokeh.Model.Nullable{String} = nothing

    user_select :: Bokeh.Model.Nullable{String} = nothing

    flood_opacity :: Bokeh.Model.Nullable{String} = nothing

    border_left :: Bokeh.Model.Nullable{String} = nothing

    margin_left :: Bokeh.Model.Nullable{String} = nothing

    clip_path :: Bokeh.Model.Nullable{String} = nothing

    line_height :: Bokeh.Model.Nullable{String} = nothing

    flex_shrink :: Bokeh.Model.Nullable{String} = nothing

    rotate :: Bokeh.Model.Nullable{String} = nothing

    border_inline_start :: Bokeh.Model.Nullable{String} = nothing

    border_inline_end :: Bokeh.Model.Nullable{String} = nothing

    line_break :: Bokeh.Model.Nullable{String} = nothing

    font_kerning :: Bokeh.Model.Nullable{String} = nothing

    border_top_width :: Bokeh.Model.Nullable{String} = nothing

    border_collapse :: Bokeh.Model.Nullable{String} = nothing

    transform_style :: Bokeh.Model.Nullable{String} = nothing

    grid_gap :: Bokeh.Model.Nullable{String} = nothing

    syncable :: Bool = true

    font_variant_numeric :: Bokeh.Model.Nullable{String} = nothing

    height :: Bokeh.Model.Nullable{String} = nothing

    tab_size :: Bokeh.Model.Nullable{String} = nothing

    stroke_dasharray :: Bokeh.Model.Nullable{String} = nothing

    filter :: Bokeh.Model.Nullable{String} = nothing

    flex_direction :: Bokeh.Model.Nullable{String} = nothing

    padding_inline_start :: Bokeh.Model.Nullable{String} = nothing

    touch_action :: Bokeh.Model.Nullable{String} = nothing

    animation_duration :: Bokeh.Model.Nullable{String} = nothing

    border_block_end :: Bokeh.Model.Nullable{String} = nothing

    border_top_right_radius :: Bokeh.Model.Nullable{String} = nothing

    padding_block_end :: Bokeh.Model.Nullable{String} = nothing

    shape_rendering :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{String} = nothing

    column_fill :: Bokeh.Model.Nullable{String} = nothing

    gap :: Bokeh.Model.Nullable{String} = nothing

    break_inside :: Bokeh.Model.Nullable{String} = nothing

    border_left_style :: Bokeh.Model.Nullable{String} = nothing

    padding_block_start :: Bokeh.Model.Nullable{String} = nothing

    page_break_after :: Bokeh.Model.Nullable{String} = nothing

    margin :: Bokeh.Model.Nullable{String} = nothing

    border_top_left_radius :: Bokeh.Model.Nullable{String} = nothing

    text_rendering :: Bokeh.Model.Nullable{String} = nothing

    column_span :: Bokeh.Model.Nullable{String} = nothing

    border_image_slice :: Bokeh.Model.Nullable{String} = nothing

    background_clip :: Bokeh.Model.Nullable{String} = nothing

    transition_property :: Bokeh.Model.Nullable{String} = nothing

    columns :: Bokeh.Model.Nullable{String} = nothing

    animation_direction :: Bokeh.Model.Nullable{String} = nothing

    grid_column :: Bokeh.Model.Nullable{String} = nothing

    font_feature_settings :: Bokeh.Model.Nullable{String} = nothing

    clip :: Bokeh.Model.Nullable{String} = nothing

    outline_width :: Bokeh.Model.Nullable{String} = nothing

    flex_basis :: Bokeh.Model.Nullable{String} = nothing

    mask_repeat :: Bokeh.Model.Nullable{String} = nothing

    border_right_style :: Bokeh.Model.Nullable{String} = nothing

    overscroll_behavior :: Bokeh.Model.Nullable{String} = nothing

    margin_bottom :: Bokeh.Model.Nullable{String} = nothing

    box_sizing :: Bokeh.Model.Nullable{String} = nothing

    content :: Bokeh.Model.Nullable{String} = nothing

    font_family :: Bokeh.Model.Nullable{String} = nothing

    break_after :: Bokeh.Model.Nullable{String} = nothing

    text_shadow :: Bokeh.Model.Nullable{String} = nothing

    border_style :: Bokeh.Model.Nullable{String} = nothing

    border_inline_start_style :: Bokeh.Model.Nullable{String} = nothing

    scroll_behavior :: Bokeh.Model.Nullable{String} = nothing

    left :: Bokeh.Model.Nullable{String} = nothing

    animation :: Bokeh.Model.Nullable{String} = nothing

    overflow_wrap :: Bokeh.Model.Nullable{String} = nothing

    stroke_miterlimit :: Bokeh.Model.Nullable{String} = nothing

    background_position_y :: Bokeh.Model.Nullable{String} = nothing

    animation_iteration_count :: Bokeh.Model.Nullable{String} = nothing

    resize :: Bokeh.Model.Nullable{String} = nothing

    cursor :: Bokeh.Model.Nullable{String} = nothing

    stroke :: Bokeh.Model.Nullable{String} = nothing

    quotes :: Bokeh.Model.Nullable{String} = nothing

    image_orientation :: Bokeh.Model.Nullable{String} = nothing

    list_style_image :: Bokeh.Model.Nullable{String} = nothing

    grid_column_end :: Bokeh.Model.Nullable{String} = nothing

    margin_block_start :: Bokeh.Model.Nullable{String} = nothing

    transition_duration :: Bokeh.Model.Nullable{String} = nothing

    marker_mid :: Bokeh.Model.Nullable{String} = nothing

    font :: Bokeh.Model.Nullable{String} = nothing

    text_align_last :: Bokeh.Model.Nullable{String} = nothing

    place_content :: Bokeh.Model.Nullable{String} = nothing

    break_before :: Bokeh.Model.Nullable{String} = nothing

    padding_top :: Bokeh.Model.Nullable{String} = nothing

    grid_template_rows :: Bokeh.Model.Nullable{String} = nothing

    grid_auto_columns :: Bokeh.Model.Nullable{String} = nothing

    marker :: Bokeh.Model.Nullable{String} = nothing

    box_shadow :: Bokeh.Model.Nullable{String} = nothing

    column_width :: Bokeh.Model.Nullable{String} = nothing

    border_block_start :: Bokeh.Model.Nullable{String} = nothing

    word_spacing :: Bokeh.Model.Nullable{String} = nothing

    font_variant_position :: Bokeh.Model.Nullable{String} = nothing

    fill :: Bokeh.Model.Nullable{String} = nothing

    animation_delay :: Bokeh.Model.Nullable{String} = nothing

    background_position :: Bokeh.Model.Nullable{String} = nothing

    border_top :: Bokeh.Model.Nullable{String} = nothing

    border_block_start_style :: Bokeh.Model.Nullable{String} = nothing

    hyphens :: Bokeh.Model.Nullable{String} = nothing

    color_interpolation_filters :: Bokeh.Model.Nullable{String} = nothing

    ruby_position :: Bokeh.Model.Nullable{String} = nothing

    align_self :: Bokeh.Model.Nullable{String} = nothing

    pointer_events :: Bokeh.Model.Nullable{String} = nothing

    all :: Bokeh.Model.Nullable{String} = nothing

    orphans :: Bokeh.Model.Nullable{String} = nothing

    border_block_end_style :: Bokeh.Model.Nullable{String} = nothing

    border_inline_start_width :: Bokeh.Model.Nullable{String} = nothing

    overscroll_behavior_block :: Bokeh.Model.Nullable{String} = nothing

    clear :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    column_rule_width :: Bokeh.Model.Nullable{String} = nothing

    grid_row :: Bokeh.Model.Nullable{String} = nothing

    margin_inline_end :: Bokeh.Model.Nullable{String} = nothing

    page_break_inside :: Bokeh.Model.Nullable{String} = nothing

    text_emphasis :: Bokeh.Model.Nullable{String} = nothing

    column_rule_style :: Bokeh.Model.Nullable{String} = nothing

    grid_column_start :: Bokeh.Model.Nullable{String} = nothing

    border_bottom_left_radius :: Bokeh.Model.Nullable{String} = nothing

    place_items :: Bokeh.Model.Nullable{String} = nothing

    list_style :: Bokeh.Model.Nullable{String} = nothing

    grid_auto_flow :: Bokeh.Model.Nullable{String} = nothing

    grid_area :: Bokeh.Model.Nullable{String} = nothing

    transition_timing_function :: Bokeh.Model.Nullable{String} = nothing

    text_justify :: Bokeh.Model.Nullable{String} = nothing

    margin_inline_start :: Bokeh.Model.Nullable{String} = nothing

    flex :: Bokeh.Model.Nullable{String} = nothing

    perspective :: Bokeh.Model.Nullable{String} = nothing

    border_image_outset :: Bokeh.Model.Nullable{String} = nothing

    font_variant :: Bokeh.Model.Nullable{String} = nothing

    max_height :: Bokeh.Model.Nullable{String} = nothing

    font_variant_east_asian :: Bokeh.Model.Nullable{String} = nothing

    padding_left :: Bokeh.Model.Nullable{String} = nothing

    stroke_linecap :: Bokeh.Model.Nullable{String} = nothing

    transform :: Bokeh.Model.Nullable{String} = nothing

    glyph_orientation_vertical :: Bokeh.Model.Nullable{String} = nothing

    margin_block_end :: Bokeh.Model.Nullable{String} = nothing

    white_space :: Bokeh.Model.Nullable{String} = nothing

    border_bottom_color :: Bokeh.Model.Nullable{String} = nothing

    stroke_dashoffset :: Bokeh.Model.Nullable{String} = nothing

    stop_opacity :: Bokeh.Model.Nullable{String} = nothing

    border_block_start_color :: Bokeh.Model.Nullable{String} = nothing

    min_width :: Bokeh.Model.Nullable{String} = nothing

    empty_cells :: Bokeh.Model.Nullable{String} = nothing

    overscroll_behavior_y :: Bokeh.Model.Nullable{String} = nothing

    border_image_source :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    transform_box :: Bokeh.Model.Nullable{String} = nothing

    max_width :: Bokeh.Model.Nullable{String} = nothing

    will_change :: Bokeh.Model.Nullable{String} = nothing

    column_count :: Bokeh.Model.Nullable{String} = nothing

    float :: Bokeh.Model.Nullable{String} = nothing

    display :: Bokeh.Model.Nullable{String} = nothing

    animation_timing_function :: Bokeh.Model.Nullable{String} = nothing

    padding :: Bokeh.Model.Nullable{String} = nothing

    grid :: Bokeh.Model.Nullable{String} = nothing

    grid_template_columns :: Bokeh.Model.Nullable{String} = nothing

    flex_flow :: Bokeh.Model.Nullable{String} = nothing

    stroke_linejoin :: Bokeh.Model.Nullable{String} = nothing

    max_inline_size :: Bokeh.Model.Nullable{String} = nothing

    direction :: Bokeh.Model.Nullable{String} = nothing

    caret_color :: Bokeh.Model.Nullable{String} = nothing

    width :: Bokeh.Model.Nullable{String} = nothing

    border_bottom_right_radius :: Bokeh.Model.Nullable{String} = nothing

    mask_type :: Bokeh.Model.Nullable{String} = nothing

    justify_self :: Bokeh.Model.Nullable{String} = nothing

    border_inline_end_color :: Bokeh.Model.Nullable{String} = nothing

    grid_template_areas :: Bokeh.Model.Nullable{String} = nothing

    table_layout :: Bokeh.Model.Nullable{String} = nothing

    text_emphasis_color :: Bokeh.Model.Nullable{String} = nothing

    border_block_end_width :: Bokeh.Model.Nullable{String} = nothing

    border_left_width :: Bokeh.Model.Nullable{String} = nothing

    word_break :: Bokeh.Model.Nullable{String} = nothing

    writing_mode :: Bokeh.Model.Nullable{String} = nothing

    mask_size :: Bokeh.Model.Nullable{String} = nothing

    padding_inline_end :: Bokeh.Model.Nullable{String} = nothing

    animation_name :: Bokeh.Model.Nullable{String} = nothing

    text_anchor :: Bokeh.Model.Nullable{String} = nothing

    background_size :: Bokeh.Model.Nullable{String} = nothing

    margin_top :: Bokeh.Model.Nullable{String} = nothing

    text_transform :: Bokeh.Model.Nullable{String} = nothing

    animation_fill_mode :: Bokeh.Model.Nullable{String} = nothing

    stop_color :: Bokeh.Model.Nullable{String} = nothing

    baseline_shift :: Bokeh.Model.Nullable{String} = nothing

    text_orientation :: Bokeh.Model.Nullable{String} = nothing

    outline_color :: Bokeh.Model.Nullable{String} = nothing

    outline_style :: Bokeh.Model.Nullable{String} = nothing

    max_block_size :: Bokeh.Model.Nullable{String} = nothing

    border_right :: Bokeh.Model.Nullable{String} = nothing

    background_repeat :: Bokeh.Model.Nullable{String} = nothing

    list_style_type :: Bokeh.Model.Nullable{String} = nothing

    font_size_adjust :: Bokeh.Model.Nullable{String} = nothing

    word_wrap :: Bokeh.Model.Nullable{String} = nothing

    text_emphasis_style :: Bokeh.Model.Nullable{String} = nothing

    translate :: Bokeh.Model.Nullable{String} = nothing

    inline_size :: Bokeh.Model.Nullable{String} = nothing

    opacity :: Bokeh.Model.Nullable{String} = nothing

    caption_side :: Bokeh.Model.Nullable{String} = nothing

    letter_spacing :: Bokeh.Model.Nullable{String} = nothing

    background_origin :: Bokeh.Model.Nullable{String} = nothing

    place_self :: Bokeh.Model.Nullable{String} = nothing

    text_emphasis_position :: Bokeh.Model.Nullable{String} = nothing

    marker_start :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    flex_wrap :: Bokeh.Model.Nullable{String} = nothing

    min_height :: Bokeh.Model.Nullable{String} = nothing

    position :: Bokeh.Model.Nullable{String} = nothing

    text_overflow :: Bokeh.Model.Nullable{String} = nothing

    scale :: Bokeh.Model.Nullable{String} = nothing

    mask_image :: Bokeh.Model.Nullable{String} = nothing

    text_decoration_color :: Bokeh.Model.Nullable{String} = nothing

    border_bottom :: Bokeh.Model.Nullable{String} = nothing

    color_interpolation :: Bokeh.Model.Nullable{String} = nothing

    visibility :: Bokeh.Model.Nullable{String} = nothing

    border_bottom_width :: Bokeh.Model.Nullable{String} = nothing

    stroke_opacity :: Bokeh.Model.Nullable{String} = nothing

    column_rule_color :: Bokeh.Model.Nullable{String} = nothing

    align_content :: Bokeh.Model.Nullable{String} = nothing

    z_index :: Bokeh.Model.Nullable{String} = nothing

    unicode_bidi :: Bokeh.Model.Nullable{String} = nothing

    border_left_color :: Bokeh.Model.Nullable{String} = nothing

    object_fit :: Bokeh.Model.Nullable{String} = nothing

    counter_reset :: Bokeh.Model.Nullable{String} = nothing

    border_image_width :: Bokeh.Model.Nullable{String} = nothing

    perspective_origin :: Bokeh.Model.Nullable{String} = nothing

    border_bottom_style :: Bokeh.Model.Nullable{String} = nothing

    border_right_color :: Bokeh.Model.Nullable{String} = nothing

    font_variant_caps :: Bokeh.Model.Nullable{String} = nothing

    overscroll_behavior_x :: Bokeh.Model.Nullable{String} = nothing

    tags :: Vector{Any}

    text_combine_upright :: Bokeh.Model.Nullable{String} = nothing

    dominant_baseline :: Bokeh.Model.Nullable{String} = nothing

    overflow_anchor :: Bokeh.Model.Nullable{String} = nothing

    outline_offset :: Bokeh.Model.Nullable{String} = nothing

    overflow_x :: Bokeh.Model.Nullable{String} = nothing

    column_gap :: Bokeh.Model.Nullable{String} = nothing

    animation_play_state :: Bokeh.Model.Nullable{String} = nothing

    border_top_style :: Bokeh.Model.Nullable{String} = nothing

    border_image_repeat :: Bokeh.Model.Nullable{String} = nothing

    font_synthesis :: Bokeh.Model.Nullable{String} = nothing

    grid_column_gap :: Bokeh.Model.Nullable{String} = nothing

    transition :: Bokeh.Model.Nullable{String} = nothing

    grid_template :: Bokeh.Model.Nullable{String} = nothing

    image_rendering :: Bokeh.Model.Nullable{String} = nothing

    border_inline_end_width :: Bokeh.Model.Nullable{String} = nothing

    counter_increment :: Bokeh.Model.Nullable{String} = nothing

    lighting_color :: Bokeh.Model.Nullable{String} = nothing

    order :: Bokeh.Model.Nullable{String} = nothing

    border_top_color :: Bokeh.Model.Nullable{String} = nothing

    border_radius :: Bokeh.Model.Nullable{String} = nothing

    grid_row_start :: Bokeh.Model.Nullable{String} = nothing

    padding_bottom :: Bokeh.Model.Nullable{String} = nothing

    transform_origin :: Bokeh.Model.Nullable{String} = nothing

    list_style_position :: Bokeh.Model.Nullable{String} = nothing

    block_size :: Bokeh.Model.Nullable{String} = nothing

    fill_opacity :: Bokeh.Model.Nullable{String} = nothing

    text_align :: Bokeh.Model.Nullable{String} = nothing

    border :: Bokeh.Model.Nullable{String} = nothing
end
