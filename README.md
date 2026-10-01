# Infraestructura Terraform - Andes Motors (Evaluación ADY1103)

Este proyecto despliega una instancia EC2 en AWS con todo lo necesario para
cumplir la sección 7 de la evaluación (Despliegue y Telemetría Base):

- Instancia Amazon EC2 (Amazon Linux 2, t2.micro).
- Security Group con acceso SSH (22) y HTTP (80).
- Monitoreo detallado de CloudWatch habilitado (métricas cada 1 minuto).
- Herramienta `stress` preinstalada para la prueba de carga.
- Un servidor web básico (Apache) para tener algo corriendo en la instancia.

## Requisitos previos

1. **AWS CLI configurado** con tus credenciales del laboratorio (AWS Academy /
   Vocareum), verificado con:
   ```bash
   aws sts get-caller-identity
   ```
2. **Terraform instalado** (verifica con `terraform -version`).
3. **Un Key Pair creado en la consola de AWS** (EC2 > Key Pairs > Create key
   pair), ya que AWS Academy no siempre permite crear key pairs vía Terraform
   sin permisos IAM extendidos. Descarga el archivo `.pem` y guárdalo en un
   lugar seguro.

## Pasos para desplegar

Desde la terminal (Git Bash) en la carpeta del proyecto:

```bash
# 1. Copia el archivo de variables de ejemplo
cp terraform.tfvars.example terraform.tfvars
```

Edita `terraform.tfvars` y coloca el `key_name` real de tu key pair.

```bash
# 2. Inicializa Terraform (descarga el provider de AWS)
terraform init

# 3. Revisa el plan de ejecución
terraform plan

# 4. Aplica los cambios (crea la instancia)
terraform apply
```

Confirma escribiendo `yes` cuando se te solicite.

Al finalizar, Terraform mostrará la IP pública y el comando SSH para
conectarte, por ejemplo:

```
public_ip = "3.85.xxx.xxx"
ssh_connection_command = "ssh -i mi-keypair.pem ec2-user@3.85.xxx.xxx"
```

## Captura para el informe (evidencia de despliegue)

Toma una captura de:
- La consola de AWS EC2 mostrando la instancia en estado `running`.
- La salida de `terraform apply` mostrando los outputs.

## Prueba de estrés (sección 7.2)

Conéctate por SSH a la instancia:

```bash
ssh -i mi-keypair.pem ec2-user@<PUBLIC_IP>
```

Ejecuta una prueba de estrés sobre CPU (ajusta el tiempo según lo necesites):

```bash
stress --cpu 2 --timeout 300
```

Esto satura 2 núcleos de CPU durante 5 minutos (300 segundos), generando un
aumento observable en las métricas.

## Monitoreo con CloudWatch (sección 7.3)

1. Ve a la consola de AWS > CloudWatch > Metrics > EC2 > Per-Instance Metrics.
2. Busca tu instancia por su `instance_id` (lo entrega el output de Terraform).
3. Selecciona la métrica `CPUUtilization`.
4. Ajusta el rango de tiempo para que abarque el momento de la prueba de
   estrés (últimas 1-3 horas).
5. Captura el gráfico mostrando el aumento del consumo de CPU antes/durante
   la prueba.

## Destruir la infraestructura al terminar

**Importante:** no olvides destruir los recursos cuando termines para no
dejar la instancia corriendo innecesariamente (especialmente en labs con
tiempo/créditos limitados):

```bash
terraform destroy
```

Confirma con `yes`.

## Notas sobre AWS Academy / Vocareum

- El rol `voclabs` usado en labs de Academy suele tener permisos limitados:
  no permite crear roles/usuarios IAM nuevos, y en algunas configuraciones
  restringe la creación de VPCs. Por eso este proyecto usa la **VPC por
  defecto** (`data "aws_vpc" "default"`) en lugar de crear una nueva.
- Si tu sesión de laboratorio expira, tus credenciales (`AWS_SESSION_TOKEN`)
  dejarán de funcionar y tendrás que volver a configurarlas antes de correr
  cualquier comando de Terraform.
# andes-motors
