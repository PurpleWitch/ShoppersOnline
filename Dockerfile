#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ShoppersOnline1.csproj", "."]
RUN dotnet restore "./ShoppersOnline1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ShoppersOnline1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ShoppersOnline1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ShoppersOnline1.dll"]