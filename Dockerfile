# 1. Etapa de compilación (SDK de .NET 8.0 o la versión que uses)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copiar los archivos de proyecto y restaurar las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copiar el resto de los archivos y compilar la app
COPY . ./
RUN dotnet publish -c Release -o out

# 2. Etapa de ejecución (Runtime de ASP.NET Core)
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Configurar la variable de entorno para que escuche en el puerto de Render
ENV ASPNETCORE_URLS=http://+:10000

# Comando para iniciar la aplicación (Asegúrate de que coincida con el nombre de tu .dll)
ENTRYPOINT ["dotnet", "ContosoPizza"]