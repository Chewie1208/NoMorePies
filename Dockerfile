# ============================
#   Build Stage
# ============================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy everything
COPY . .

# Restore dependencies
RUN dotnet restore ./src/NoMorePies_Web/NoMorePies_Web.csproj

# Publish the Web project
RUN dotnet publish ./src/NoMorePies_Web/NoMorePies_Web.csproj -c Release -o /app


# ============================
#   Runtime Stage
# ============================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy published output
COPY --from=build /app .

# Expose port (Container Apps default)
EXPOSE 8080

# Run the app
ENTRYPOINT ["dotnet", "NoMorePies_Web.dll"]
