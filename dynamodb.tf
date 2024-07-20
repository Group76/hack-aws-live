resource "aws_dynamodb_table" "patient_table" {
  name           = "Patient"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "cpf"
    type = "S"
  }
}

resource "aws_dynamodb_table" "doctor_table" {
  name           = "Doctor"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "crm"
    type = "S"
  }

  attribute {
    name = "medicalSpecialty"
    type = "S"
  }
}

resource "aws_dynamodb_table" "medical_specialties" {
  name           = "MedicalSpecialties"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "specialty"
    type = "S"
  }
}

locals {
  specialties = [
"Acupuntura","Alergia e imunologia","Anestesiologia","Angiologia","Cardiologia",
"Cirurgia cardiovascular","Cirurgia da mão","Cirurgia de cabeça e pescoço",
"Cirurgia do aparelho digestivo","Cirurgia geral","Cirurgia oncológica","Cirurgia pediátrica",
"Cirurgia plástica","Cirurgia torácica","Cirurgia vascular","Clínica médica","Coloproctologia","Dermatologia",
"Endocrinologia e metabologia","Endoscopia","Gastroenterologia","Genética médica","Geriatria",
"Ginecologia e obstetrícia","Hematologia e hemoterapia","Homeopatia","Infectologia","Mastologia",
"Medicina de emergência","Medicina de família e comunidade","Medicina do trabalho","Medicina de tráfego","Medicina esportiva",
"Medicina física e reabilitação","Medicina intensiva","Medicina legal e perícia médica","Medicina nuclear",
"Medicina preventiva e social","Nefrologia","Neurocirurgia","Neurologia","Nutrologia",
"Oftalmologia","Oncologia clínica","Ortopedia e traumatologia","Otorrinolaringologia",
"Patologia","Patologia clínica/medicina laboratorial","Pediatria","Pneumologia",
"Psiquiatria","Radiologia e diagnóstico por imagem","Radioterapia","Reumatologia","Urologia"
  ]
}

resource "aws_dynamodb_table_item" "medical_specialty_item" {
  for_each = { for specialty in local.specialties : uuid() => specialty }

  table_name = aws_dynamodb_table.medical_specialties.name

  hash_key = each.key

  item = jsonencode({
    id         = each.key
    specialty  = each.value
  })
}