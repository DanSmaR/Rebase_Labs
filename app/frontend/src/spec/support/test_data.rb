def db_result
  [
    {
      "token"=>"IQCZ17",
      "exam_date"=>"2021-08-05",
      "cpf"=>"048.973.170-88",
      "patient_name"=>"Emilly Batista Neto",
      "patient_email"=>"gerald.crona@ebert-quigley.com",
      "birth_date"=>"2001-03-11",
      "address"=>"165 Rua Rafaela",
      "city"=>"Ituverava",
      "state"=>"Alagoas",
      "crm"=>"B000BJ20J4",
      "crm_state"=>"PI",
      "doctor_name"=>"Maria Luiza Pires",
      "doctor_email"=>"denna@wisozk.biz",
      "exam_type"=>"hemácias",
      "exam_limits"=>"45-52",
      "exam_result"=>"97"
    },
    {
      "token"=>"IQCZ17",
      "exam_date"=>"2021-08-05",
      "cpf"=>"048.973.170-88",
      "patient_name"=>"Emilly Batista Neto",
      "patient_email"=>"gerald.crona@ebert-quigley.com",
      "birth_date"=>"2001-03-11",
      "address"=>"165 Rua Rafaela",
      "city"=>"Ituverava",
      "state"=>"Alagoas",
      "crm"=>"B000BJ20J4",
      "crm_state"=>"PI",
      "doctor_name"=>"Maria Luiza Pires",
      "doctor_email"=>"denna@wisozk.biz",
      "exam_type"=>"leucócitos",
      "exam_limits"=>"9-61",
      "exam_result"=>"89"
    },
    {
      "token"=>"0W9I67",
      "exam_date"=>"2021-07-09",
      "cpf"=>"048.108.026-04",
      "patient_name"=>"Juliana dos Reis Filho",
      "patient_email"=>"mariana_crist@kutch-torp.com",
      "birth_date"=>"1995-07-03",
      "address"=>"527 Rodovia Júlio",
      "city"=>"Lagoa da Canoa",
      "state"=>"Paraíba",
      "crm"=>"B0002IQM66",
      "crm_state"=>"SC",
      "doctor_name"=>"Maria Helena Ramalho",
      "doctor_email"=>"rayford@kemmer-kunze.info",
      "exam_type"=>"hemácias",
      "exam_limits"=>"45-52",
      "exam_result"=>"28"
    },
    {
      "token"=>"0W9I67",
      "exam_date"=>"2021-07-09",
      "cpf"=>"048.108.026-04",
      "patient_name"=>"Juliana dos Reis Filho",
      "patient_email"=>"mariana_crist@kutch-torp.com",
      "birth_date"=>"1995-07-03",
      "address"=>"527 Rodovia Júlio",
      "city"=>"Lagoa da Canoa",
      "state"=>"Paraíba",
      "crm"=>"B0002IQM66",
      "crm_state"=>"SC",
      "doctor_name"=>"Maria Helena Ramalho",
      "doctor_email"=>"rayford@kemmer-kunze.info",
      "exam_type"=>"leucócitos",
      "exam_limits"=>"9-61",
      "exam_result"=>"91"
    }
  ]
end

def api_response
  [
    {
      "token"=>"IQCZ17",
      "exam_date"=>"2021-08-05",
      "cpf"=>"048.973.170-88",
      "name"=>"Emilly Batista Neto",
      "email"=>"gerald.crona@ebert-quigley.com",
      "birthday"=>"2001-03-11",
      "address"=>"165 Rua Rafaela",
      "city"=>"Ituverava",
      "state"=>"Alagoas",
      "doctor"=>{
        "crm"=>"B000BJ20J4",
        "crm_state"=>"PI",
        "name"=>"Maria Luiza Pires",
        "email"=>"denna@wisozk.biz"
      },
      "tests"=>[
        {
          "type"=>"hemácias",
          "limits"=>"45-52",
          "result"=>"97"
        },
        {
          "type"=>"leucócitos",
          "limits"=>"9-61",
          "result"=>"89"
        }
      ]
    },
    {
      "token"=>"0W9I67",
      "exam_date"=>"2021-07-09",
      "cpf"=>"048.108.026-04",
      "name"=>"Juliana dos Reis Filho",
      "email"=>"mariana_crist@kutch-torp.com",
      "birthday"=>"1995-07-03",
      "address"=>"527 Rodovia Júlio",
      "city"=>"Lagoa da Canoa",
      "state"=>"Paraíba",
      "doctor"=>{
        "crm"=>"B0002IQM66",
        "crm_state"=>"SC",
        "name"=>"Maria Helena Ramalho",
        "email"=>"rayford@kemmer-kunze.info"
      },
      "tests"=>[
        {
          "type"=>"hemácias",
          "limits"=>"45-52",
          "result"=>"28"
        },
        {
          "type"=>"leucócitos",
          "limits"=>"9-61",
          "result"=>"91"
        }
      ]
    }
  ]
end
