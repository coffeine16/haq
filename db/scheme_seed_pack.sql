-- ============================================================
-- Haq — Scheme Seed Pack (Rajasthan + Central)
-- Run in Supabase SQL Editor. Safe to re-run (ON CONFLICT updates).
-- Eligibility uses only fields the profiler extracts:
--   gender, age, marital_status, annual_income, category, state, occupation
-- ============================================================

INSERT INTO schemes (id, version, config, active) VALUES

-- 1. Widow Pension (already seeded earlier — included for completeness)
('rj_widow_pension', 1, '{
  "id":"rj_widow_pension","version":1,
  "name":{"en":"Widow Pension (Rajasthan)","hi":"विधवा पेंशन (राजस्थान)"},
  "benefit":{"type":"monthly_cash","amount_inr":1500},"effort_score":2,
  "eligibility":{"all":[
    {"field":"gender","op":"eq","value":"female"},
    {"field":"marital_status","op":"eq","value":"widowed"},
    {"field":"age","op":"gte","value":18},
    {"field":"annual_income","op":"lte","value":48000},
    {"field":"state","op":"eq","value":"RJ"}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"income_certificate"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/rj_widow_pension.pdf"},
  "slas":{"acknowledge_days":7,"decision_days":45},
  "appeal":{"route":"cpgrams","grievance_dept":"Social Justice & Empowerment, Rajasthan"}
}', true),

-- 2. Old Age Pension (Rajasthan)
('rj_old_age_pension', 1, '{
  "id":"rj_old_age_pension","version":1,
  "name":{"en":"Old Age Pension (Rajasthan)","hi":"वृद्धावस्था पेंशन (राजस्थान)"},
  "benefit":{"type":"monthly_cash","amount_inr":1150},"effort_score":2,
  "eligibility":{"all":[
    {"field":"age","op":"gte","value":58},
    {"field":"annual_income","op":"lte","value":48000},
    {"field":"state","op":"eq","value":"RJ"}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"income_certificate"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/rj_old_age.pdf"},
  "slas":{"acknowledge_days":7,"decision_days":45},
  "appeal":{"route":"cpgrams","grievance_dept":"Social Justice & Empowerment, Rajasthan"}
}', true),

-- 3. PM Ujjwala (Central) — free LPG
('pm_ujjwala', 1, '{
  "id":"pm_ujjwala","version":1,
  "name":{"en":"PM Ujjwala Yojana (LPG Connection)","hi":"पीएम उज्ज्वला योजना"},
  "benefit":{"type":"one_time","amount_inr":1600},"effort_score":1,
  "eligibility":{"all":[
    {"field":"gender","op":"eq","value":"female"},
    {"field":"annual_income","op":"lte","value":100000}]},
  "required_docs":[{"type":"aadhaar_masked"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/ujjwala.pdf"},
  "slas":{"acknowledge_days":5,"decision_days":30},
  "appeal":{"route":"cpgrams","grievance_dept":"Ministry of Petroleum"}
}', true),

-- 4. Ekal Nari (Single Woman) Samman Pension (Rajasthan)
('rj_ekal_nari_pension', 1, '{
  "id":"rj_ekal_nari_pension","version":1,
  "name":{"en":"Single Woman Honour Pension (Rajasthan)","hi":"एकल नारी सम्मान पेंशन"},
  "benefit":{"type":"monthly_cash","amount_inr":1150},"effort_score":2,
  "eligibility":{"all":[
    {"field":"gender","op":"eq","value":"female"},
    {"field":"marital_status","op":"in","value":["widowed","divorced","single"]},
    {"field":"age","op":"gte","value":18},
    {"field":"annual_income","op":"lte","value":48000},
    {"field":"state","op":"eq","value":"RJ"}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"income_certificate"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/rj_ekal_nari.pdf"},
  "slas":{"acknowledge_days":7,"decision_days":45},
  "appeal":{"route":"cpgrams","grievance_dept":"Social Justice & Empowerment, Rajasthan"}
}', true),

-- 5. Special Ability (Disability) Pension (Rajasthan)
('rj_viklang_pension', 1, '{
  "id":"rj_viklang_pension","version":1,
  "name":{"en":"Special Ability Pension (Rajasthan)","hi":"विशेष योग्यजन पेंशन"},
  "benefit":{"type":"monthly_cash","amount_inr":1500},"effort_score":3,
  "eligibility":{"all":[
    {"field":"disability","op":"eq","value":"yes"},
    {"field":"annual_income","op":"lte","value":60000},
    {"field":"state","op":"eq","value":"RJ"}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"disability_certificate"},{"type":"income_certificate"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/rj_viklang.pdf"},
  "slas":{"acknowledge_days":7,"decision_days":60},
  "appeal":{"route":"cpgrams","grievance_dept":"Social Justice & Empowerment, Rajasthan"}
}', true),

-- 6. Palanhar Yojana (Rajasthan) — orphan/destitute child care
('rj_palanhar', 1, '{
  "id":"rj_palanhar","version":1,
  "name":{"en":"Palanhar Yojana (Child Care)","hi":"पालनहार योजना"},
  "benefit":{"type":"monthly_cash","amount_inr":1000},"effort_score":3,
  "eligibility":{"all":[
    {"field":"caring_for_orphan","op":"eq","value":"yes"},
    {"field":"annual_income","op":"lte","value":120000},
    {"field":"state","op":"eq","value":"RJ"}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"child_certificate"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/rj_palanhar.pdf"},
  "slas":{"acknowledge_days":7,"decision_days":45},
  "appeal":{"route":"cpgrams","grievance_dept":"Social Justice & Empowerment, Rajasthan"}
}', true),

-- 7. Mukhyamantri Kanyadan (girl marriage assistance, Rajasthan)
('rj_kanyadan', 1, '{
  "id":"rj_kanyadan","version":1,
  "name":{"en":"CM Kanyadan Yojana (Marriage Aid)","hi":"मुख्यमंत्री कन्यादान योजना"},
  "benefit":{"type":"one_time","amount_inr":31000},"effort_score":3,
  "eligibility":{"all":[
    {"field":"daughter_marriage","op":"eq","value":"yes"},
    {"field":"annual_income","op":"lte","value":50000},
    {"field":"state","op":"eq","value":"RJ"}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"income_certificate"},{"type":"marriage_proof"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/rj_kanyadan.pdf"},
  "slas":{"acknowledge_days":10,"decision_days":60},
  "appeal":{"route":"cpgrams","grievance_dept":"Social Justice & Empowerment, Rajasthan"}
}', true),

-- 8. PM-KISAN (Central) — farmer income support
('pm_kisan', 1, '{
  "id":"pm_kisan","version":1,
  "name":{"en":"PM-KISAN (Farmer Income Support)","hi":"पीएम-किसान सम्मान निधि"},
  "benefit":{"type":"yearly_cash","amount_inr":6000},"effort_score":2,
  "eligibility":{"all":[
    {"field":"occupation","op":"in","value":["farmer","kisan","agriculture","khetihar"]}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"land_record"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/pm_kisan.pdf"},
  "slas":{"acknowledge_days":7,"decision_days":30},
  "appeal":{"route":"cpgrams","grievance_dept":"Ministry of Agriculture"}
}', true),

-- 9. Chiranjeevi Health Insurance (Rajasthan)
('rj_chiranjeevi', 1, '{
  "id":"rj_chiranjeevi","version":1,
  "name":{"en":"Chiranjeevi Health Insurance (Rajasthan)","hi":"मुख्यमंत्री चिरंजीवी स्वास्थ्य बीमा"},
  "benefit":{"type":"insurance_cover","amount_inr":2500000},"effort_score":2,
  "eligibility":{"all":[
    {"field":"state","op":"eq","value":"RJ"}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"jan_aadhaar"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/rj_chiranjeevi.pdf"},
  "slas":{"acknowledge_days":3,"decision_days":15},
  "appeal":{"route":"cpgrams","grievance_dept":"Medical & Health, Rajasthan"}
}', true),

-- 10. PM Awas Yojana - Gramin (Central) — housing
('pm_awas_g', 1, '{
  "id":"pm_awas_g","version":1,
  "name":{"en":"PM Awas Yojana (Rural Housing)","hi":"पीएम आवास योजना (ग्रामीण)"},
  "benefit":{"type":"one_time","amount_inr":120000},"effort_score":4,
  "eligibility":{"all":[
    {"field":"annual_income","op":"lte","value":60000}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"income_certificate"},{"type":"land_proof"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/pm_awas.pdf"},
  "slas":{"acknowledge_days":15,"decision_days":90},
  "appeal":{"route":"cpgrams","grievance_dept":"Ministry of Rural Development"}
}', true),

-- 11. National Family Benefit Scheme (death of breadwinner)
('nfbs', 1, '{
  "id":"nfbs","version":1,
  "name":{"en":"National Family Benefit Scheme","hi":"राष्ट्रीय परिवार लाभ योजना"},
  "benefit":{"type":"one_time","amount_inr":20000},"effort_score":3,
  "eligibility":{"all":[
    {"field":"breadwinner_died","op":"eq","value":"yes"},
    {"field":"annual_income","op":"lte","value":48000},
    {"field":"state","op":"eq","value":"RJ"}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"death_certificate"},{"type":"income_certificate"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/nfbs.pdf"},
  "slas":{"acknowledge_days":10,"decision_days":45},
  "appeal":{"route":"cpgrams","grievance_dept":"Social Justice & Empowerment, Rajasthan"}
}', true),

-- 12. Mukhyamantri Rajshri (girl child welfare, Rajasthan)
('rj_rajshri', 1, '{
  "id":"rj_rajshri","version":1,
  "name":{"en":"CM Rajshri Yojana (Girl Child)","hi":"मुख्यमंत्री राजश्री योजना"},
  "benefit":{"type":"staggered_cash","amount_inr":50000},"effort_score":2,
  "eligibility":{"all":[
    {"field":"gender","op":"eq","value":"female"},
    {"field":"age","op":"lte","value":18},
    {"field":"state","op":"eq","value":"RJ"}]},
  "required_docs":[{"type":"aadhaar_masked"},{"type":"birth_certificate"},{"type":"jan_aadhaar"}],
  "execution":{"tier2_recipe":null,"tier3_template":"templates/rj_rajshri.pdf"},
  "slas":{"acknowledge_days":7,"decision_days":30},
  "appeal":{"route":"cpgrams","grievance_dept":"Women & Child Development, Rajasthan"}
}', true)

ON CONFLICT (id) DO UPDATE
  SET config = EXCLUDED.config,
      version = EXCLUDED.version,
      active  = EXCLUDED.active;

-- Verify
SELECT id,
       config->'name'->>'en'      AS name,
       config->'benefit'->>'amount_inr' AS amount,
       config->>'effort_score'    AS effort
FROM schemes ORDER BY id;
