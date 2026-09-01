# ============================
#   Build Stage (.NET 10 SDK)
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
#   Runtime Stage (ASP.NET 10 + TLS)
# ============================
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final

# Install TLS support (missing in ASP.NET 10)
RUN apt-get update && apt-get install -y \
    openssl \
    ca-certificates \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy published output
COPY --from=build /app .

# Expose port (Container Apps default)
EXPOSE 8080

# Run the app
ENTRYPOINT ["dotnet", "NoMorePies_Web.dll"]
