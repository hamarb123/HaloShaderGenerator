﻿#ifndef _BUMP_MAPPING_HLSLI
#define _BUMP_MAPPING_HLSLI

#include "../helpers/types.hlsli"
#include "../helpers/math.hlsli"
#include "../helpers/bumpmap_math.hlsli"
#include "../registers/shader.hlsli"

float3 calc_bumpmap_off_ps(
	float3 tangent,
	float3 binormal,
	float3 normal,
	float2 texcoord) 
{
	return normal;
}

float3 calc_bumpmap_default_ps(
	float3 tangent,
	float3 binormal,
	float3 normal,
	float2 texcoord
) 
{
    float2 bump_map_texcoord = apply_xform2d(texcoord, bump_map_xform);
    float3 bump_map_sample = sample_normal_2d(bump_map, bump_map_texcoord);
	return normal_transform(tangent, binormal, normal, bump_map_sample);
}

float3 calc_bumpmap_detail_ps(
	float3 tangent,
	float3 binormal,
	float3 normal,
	float2 texcoord
)
{
    float3 bump_map_sample = sample_normal_2d(bump_map, apply_xform2d(texcoord, bump_map_xform));
    float3 bump_detail_map_sample = sample_normal_2d(bump_detail_map, apply_xform2d(texcoord, bump_detail_map_xform));
    float3 bump_plus_detail = bump_map_sample + bump_detail_map_sample * bump_detail_coefficient.x;
	return normal_transform(tangent, binormal, normal, bump_plus_detail);
}

float3 calc_bumpmap_detail_masked_ps(
	float3 tangent,
	float3 binormal,
	float3 normal,
	float2 texcoord
)
{
    float3 bump_map_sample = sample_normal_2d(bump_map, apply_xform2d(texcoord, bump_map_xform));
    float3 bump_detail_map_sample = sample_normal_2d(bump_detail_map, apply_xform2d(texcoord, bump_detail_map_xform));
	float4 mask_map_sample = tex2D(bump_detail_mask_map, apply_xform2d(texcoord, bump_detail_mask_map_xform));
    float3 bump_plus_detail = bump_map_sample + bump_detail_map_sample * bump_detail_coefficient.x * mask_map_sample.xyz;
	return normal_transform(tangent, binormal, normal, bump_plus_detail);
}

float3 calc_bumpmap_detail_plus_detail_masked_ps(
	float3 tangent,
	float3 binormal,
	float3 normal,
	float2 texcoord
) {
    float3 bump_map_sample = sample_normal_2d(bump_map, apply_xform2d(texcoord, bump_map_xform));
    float3 bump_detail_map_sample = sample_normal_2d(bump_detail_map, apply_xform2d(texcoord, bump_detail_map_xform));
	float3 bump_plus_detail = bump_map_sample + bump_detail_map_sample * bump_detail_coefficient.x;
	return normal_transform(tangent, binormal, normal, bump_plus_detail);

    //NOTE: This is a new saber shader
    //TODO: We need to implement the mask + second detail MS30 only
}

void calc_bumpmap_off_vs()
{

}

void calc_bumpmap_default_vs()
{

}

void calc_bumpmap_detail_vs()
{

}

//fixup
#define calc_bumpmap_standard_ps calc_bumpmap_default_ps
#define calc_bumpmap_standard_vs calc_bumpmap_default_vs

#ifndef calc_bumpmap_ps
#define calc_bumpmap_ps calc_bumpmap_off_ps
#endif
#ifndef calc_bumpmap_vs
#define calc_bumpmap_vs calc_bumpmap_off_vs
#endif

#endif