# 1. Etapa de compilación (Cambiado a SDK de .NET 9.0)
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
WORKDIR /app

# Copiar los archivos de proyecto y restaurar las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copiar el resto de los archivos y compilar la app
COPY . ./
RUN dotnet publish -c Release -o out

# 2. Etapa de ejecución (Cambiado a Runtime de ASP.NET Core 9.0)
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build-env /app/out .

# Configurar la variable de entorno para que escuche en el puerto de Render
ENV ASPNETCORE_URLS=http://+:10000

# Comando para iniciar la aplicación
ENTRYPOINT ["dotnet", "ContosoPizza.dll"]