# ============================
#   Build Stage
# ============================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything
COPY . .

# Restore dependencies
RUN dotnet restore ./repos/nomorepies/nomorepies.slnx

# Publish the Web project
RUN dotnet publish src/NoMorePies_Web/NoMorePies_Web.csproj -c Release -o /app/publish


# ============================
#   Runtime Stage
# ============================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy published output
COPY --from=build /app/publish .

# Expose port (Container Apps default)
EXPOSE 8080

# Run the app
ENTRYPOINT ["dotnet", "NoMorePies_Web.dll"]
