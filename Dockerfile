# Stage 1: Build / Dependencies stage
FROM python:3.11-slim AS builder

WORKDIR /app

# Install dependencies into a specific directory
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Runtime stage (final minimal image)
FROM python:3.11-slim AS runner

WORKDIR /app

# Copy only the installed dependencies from the builder stage
COPY --from=builder /root/.local /root/.local
COPY . /app

# Ensure scripts in .local are usable
ENV PATH=/root/.local/bin:$PATH

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["python", "app.py"]
