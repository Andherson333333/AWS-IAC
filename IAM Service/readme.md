## Que es IAM

IAM (Identity and Access Management): IAM es el servicio de AWS que te permite administrar el acceso a los recursos de AWS de manera segura. Con IAM, puedes crear y gestionar usuarios, grupos, roles y permisos para controlar quién tiene acceso a qué recursos dentro de tu cuenta de AWS

## Que es User

User (Usuario): Un usuario en IAM representa una persona o una aplicación que interactúa con AWS. Cada usuario tiene un nombre de usuario y credenciales de acceso únicas que se utilizan para iniciar sesión en la consola de AWS o para acceder a los recursos de AWS a través de la API.
  
## Que es group

Group (Grupo): Un grupo en IAM es una colección de usuarios que comparten los mismos conjuntos de permisos. En lugar de asignar permisos a cada usuario individualmente, puedes agregar usuarios a grupos y luego asignar permisos a esos grupos. Esto facilita la gestión de permisos a gran escala.

## Que son politicas

Políticas (Policies): Las políticas en IAM son documentos JSON que definen los permisos y las acciones que un usuario, grupo o rol puede realizar en recursos específicos de AWS. Las políticas se adjuntan a usuarios, grupos o roles para definir qué operaciones pueden realizar y en qué recursos.

## Que son roles

Roles (Roles): Un rol en IAM es similar a un usuario, pero se utiliza para conceder permisos temporales a una entidad de confianza, como un usuario de otro servicio de AWS, una aplicación o un servicio externo. Los roles se utilizan comúnmente para delegar acceso entre servicios de AWS y para permitir a las aplicaciones acceder a recursos de AWS de manera segura sin exponer credenciales.
