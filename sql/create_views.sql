-- Mapping of PSCIS points requires pulling data from crossings table back into assessment/remediation etc relations -
-- because required columns for each type are slightly different.

-- Pull data from crossings table into materialized views

DROP MATERIALIZED VIEW IF EXISTS bcfishpass.crossings_pscis_assessment_vw;
CREATE MATERIALIZED VIEW bcfishpass.crossings_pscis_assessment_vw AS
SELECT
  c.*,
 a.funding_project_number,
 a.funding_project,
 a.funding_source,
 a.responsible_party_name,
 a.consultant_name,
 a.assessment_date,
 a.external_crossing_reference,
 a.crew_members,
 a.stream_name,
 a.road_name,
 a.road_km_mark,
 a.road_tenure,
 a.diameter_or_span,
 a.length_or_width,
 a.continuous_embeddedment_ind,
 a.average_depth_embededdment,
 a.resemble_channel_ind,
 a.backwatered_ind,
 a.percentage_backwatered,
 a.fill_depth,
 a.outlet_drop,
 a.outlet_pool_depth,
 a.inlet_drop_ind,
 a.culvert_slope,
 a.downstream_channel_width,
 a.stream_slope,
 a.beaver_activity_ind,
 a.fish_observed_ind,
 a.valley_fill_code,
 a.valley_fill_code_desc,
 a.habitat_value_code,
 a.habitat_value_desc,
 a.stream_width_ratio,
 a.stream_width_ratio_score,
 a.culvert_length_score,
 a.embed_score,
 a.outlet_drop_score,
 a.culvert_slope_score,
 a.final_score,
 a.barrier_result_code,
 a.barrier_result_description,
 a.crossing_fix_code,
 a.crossing_fix_desc,
 a.recommended_diameter_or_span,
 a.assessment_comment,
 -- convert these into links here rather than messing about in javascript
 '<a href="'||a.ecocat_url||'">LINK</a>' as ecocat_url,
 '<a href="'||a.image_view_url||'">LINK</a>' as image_view_url,
 a.current_pscis_status,
 a.current_crossing_type_code,
 a.current_crossing_type_desc,
 a.current_crossing_subtype_code,
 a.current_crossing_subtype_desc,
 a.current_barrier_result_code,
 a.current_barrier_description
FROM bcfishpass.crossings c
INNER JOIN whse_fish.pscis_assessment_svw a
ON c.stream_crossing_id = a.stream_crossing_id
WHERE c.pscis_status = 'ASSESSED';

CREATE INDEX ON bcfishpass.crossings_pscis_assessment_vw USING GIST (geom);

-- confirmations
DROP MATERIALIZED VIEW IF EXISTS bcfishpass.crossings_pscis_habitat_confirmation_vw;
CREATE MATERIALIZED VIEW bcfishpass.crossings_pscis_habitat_confirmation_vw AS
SELECT c.*,
 h.assmt_funding_project_number,
 h.assmt_funding_project,
 h.assmt_project_id,
 h.assmt_funding_source,
 h.assmt_responsible_party_name,
 h.assmt_date,
 h.external_crossing_reference,
 h.crew_members,
 h.location_confidence_ind,
 h.stream_name,
 h.road_name,
 h.road_km_mark,
 h.road_tenure,
 h.habconf_proceed_ind,
 h.habconf_habitat_value_code,
 h.habconf_habitat_value_desc,
 h.habconf_habitat_value_rtle,
 h.habconf_verified_habitat_ind,
 h.habconf_verified_habitat_len,
 h.habconf_comments,
 -- convert these into links here rather than messing about in javascript
 '<a href="'||h.habconf_ecocat_url||'">LINK</a>' as ecocat_url,
 '<a href="'||h.habconf_image_view_url||'">LINK</a>' as image_view_url,
 h.current_pscis_status,
 h.current_crossing_type_code,
 h.current_crossing_type_desc,
 h.current_crossing_subtype_code,
 h.current_crossing_subtype_desc,
 h.current_barrier_result_code,
 h.current_barrier_description
FROM bcfishpass.crossings c
INNER JOIN whse_fish.pscis_habitat_confirmation_svw h
ON c.stream_crossing_id = h.stream_crossing_id
WHERE c.pscis_status = 'HABITAT CONFIRMATION';

CREATE INDEX ON bcfishpass.crossings_pscis_habitat_confirmation_vw USING GIST (geom);

-- designs
DROP MATERIALIZED VIEW IF EXISTS bcfishpass.crossings_pscis_design_proposal_vw;
CREATE MATERIALIZED VIEW bcfishpass.crossings_pscis_design_proposal_vw AS
SELECT c.*,
 d.funding_project_number,
 d.funding_project,
 d.project_id,
 d.funding_source,
 d.responsible_party_name,
 d.consultant_name,
 d.proposal_date,
 d.external_crossing_reference,
 d.location_confidence_ind,
 d.stream_name,
 d.road_name,
 d.road_km_mark,
 d.road_tenure,
 d.crossing_fix_code,
 d.crossing_fix_desc,
 d.proposed_diameter_or_span,
 d.estimated_design_cost,
 d.cost_benefit_calc,
 d.expiry_date,
 -- convert these into links here rather than messing about in javascript
 '<a href="'||d.ecocat_url||'">LINK</a>' as ecocat_url,
 '<a href="'||d.image_view_url||'">LINK</a>' as image_view_url,
 d.current_pscis_status,
 d.current_crossing_type_code,
 d.current_crossing_type_desc,
 d.current_crossing_subtype_code,
 d.current_crossing_subtype_desc,
 d.current_barrier_result_code,
 d.current_barrier_description
FROM bcfishpass.crossings c
INNER JOIN whse_fish.pscis_design_proposal_svw d
ON c.stream_crossing_id = d.stream_crossing_id
WHERE c.pscis_status = 'DESIGN';

CREATE INDEX ON bcfishpass.crossings_pscis_design_proposal_vw USING GIST (geom);


-- remediations
DROP MATERIALIZED VIEW IF EXISTS bcfishpass.crossings_pscis_remediation_vw;
CREATE MATERIALIZED VIEW bcfishpass.crossings_pscis_remediation_vw AS
SELECT
  c.*,
 r.funding_project_number,
 r.funding_project,
 r.project_id,
 r.funding_source,
 r.responsible_party_name,
 r.consultant_name,
 r.completion_date,
 r.remediation_id,
 r.external_crossing_reference,
 r.location_confidence_ind,
 r.stream_name,
 r.road_name,
 r.road_km_mark,
 r.road_tenure,
 r.remediation_cost,
 r.habconf_verified_habitat_len,
 r.remed_cost_benefit,
 -- convert these into links here rather than messing about in javascript
 '<a href="'||r.ecocat_url||'">LINK</a>' as ecocat_url,
 '<a href="'||r.image_view_url||'">LINK</a>' as image_view_url,
 r.current_pscis_status,
 r.current_crossing_type_code,
 r.current_crossing_type_desc,
 r.current_crossing_subtype_code,
 r.current_crossing_subtype_desc,
 r.current_barrier_result_code,
 r.current_barrier_description
FROM bcfishpass.crossings c
INNER JOIN whse_fish.pscis_remediation_svw r
ON c.stream_crossing_id = r.stream_crossing_id
WHERE c.pscis_status = 'REMEDIATED';

CREATE INDEX ON bcfishpass.crossings_pscis_remediation_vw USING GIST (geom);