// SPDX-License-Identifier: CC-BY-NC-SA-4.0+

#include "loathe.fxh"
#include "gamma.fxh"

namespace loathe 
{ 
  namespace fog
  {
    namespace ui
    {
      uniform float far_plane < __UNIFORM_DRAG_FLOAT1
        ui_label = "Far plane";
        ui_min = 0.0;
        ui_step = 1.0;
      > = RESHADE_DEPTH_LINEARIZATION_FAR_PLANE;

      uniform float4 color < __UNIFORM_COLOR_FLOAT4
        ui_label = "Color";
      > = float4(1.0, 1.0, 1.0, 1.0);

      UI_MESSAGE(help, __preprocessor_help_text__);
    } // namespace ui

    float3 ps_main(in vs_t vs): sv_target
    {
      float3 color = tex2D(loathe::backbuffer, vs.texcoord.xy).rgb;
      color = gamma::signal_to_linear(color);

      float depth = get_depth(vs.tecoord.xy, ui::far_plane);
      color = lerp(color, ui::color.rgb, depth.rrr * ui::color.a);

      color = gamma::linear_to_signal(color);
      return color;
    }
  } // namespace fog

  technique loathe_fog <ui_label = "loathe::fog";>
  {
    pass
    {
      PixelShader = loathe::fog::ps_main;
      VertexShader = loathe::vs_quad;
    }
  }
} // namespace loathe