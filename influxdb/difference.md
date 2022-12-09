[[_TOC_]]
# Main difference

## 1. Influx 1.8
InfluxDB 1.8 will continue to be maintained and receive defect fixes through the end of 2021. But InfluxDB 1.8 (and subsequent maintenance releases) will be the last official release on the 1.x line that will be built and distributed by InfluxData. However, the enterprise version is also in the 1.x version. The break update has not been released. 

## 2. Influx 2.5
InfluxDB v2.5 is the latest stable version InfluxData released.

TICK is the set of components that make up the InfluxData platform, representing the four components used to solve the chronological database problem: **Telegraf** (data collector), **InfluxDB** (chronological database), **Chronograf** (visualization UI), and **Kapacitor** (processing and monitoring service)

TICK stands for Telegraf, InfluxDB, Chronograf, and Kapacitor

![TICK](https://w2.influxdata.com/wp-content/uploads/Influx-1.0-Diagram_04.20.2020v2.png)

## 3. Flux
Flux is InfluxData's functional data scripting language designed to query, analyze, and manipulate data, and it is a replacement for InfluxQL and other SQL-like query languages.

Design principles: Inspired by Javascript, the aim is to design languages that are usable, readable, flexible, composable, testable, contributable and sharable.
> [Flux syntax basics](https://docs.influxdata.com/flux/v0.x/get-started/syntax-basics/) </br>
> [Flux standard library](https://docs.influxdata.com/flux/v0.x/stdlib/)


## 4. Comparication

### 4.1 A key overview
A **key** sum-up of the differences:

#### 4.1.1 UI
- Influx 1.8 doesn't support UI. We have to configure ourselves. While, influx 2.5 supports UI, and intergrade as a whole project.
#### 4.1.2 Flux & Influxsql
- Influx 1.8 only supports partial Flux grammar, mainly using SQL-like query language. Influx 2.5 is mainly using Flux query language but supports some SQL-like queries.
> Flux is packaged with InfluxDB v1.8+ and does not require any additional installation, however it is disabled by default and [needs to be enabled](https://docs.influxdata.com/influxdb/v1.8/flux/installation/) </br>
> [Influx-sql support](https://docs.influxdata.com/influxdb/v2.5/query-data/influxql/#influxql-support)
- To support SQL in influxdb, we have to map from database/ retention policies to organization/bucket. 
>[Please see](https://docs.influxdata.com/influxdb/v2.5/query-data/influxql/dbrp/#create-dbrp-mappings)
#### 4.1.3 File system layout
- File system layout differents:
> [1.x Layout](https://docs.influxdata.com/influxdb/v1.8/concepts/file-system-layout/) </br>
> [2.5 Layout](https://docs.influxdata.com/influxdb/v2.5/reference/internals/file-system-layout/)
#### 4.1.4 Continuous queries (CQs)
- InfluxDB OSS 2.0 replaces 1.x continuous queries (CQs) with InfluxDB tasks. To migrate continuous queries to InfluxDB 2.0 tasks. [Do the following](https://docs.influxdata.com/influxdb/v2.5/upgrade/v1-to-v2/migrate-cqs/)
#### 4.1.5 File copy method (Backup)
- File copy method (/var/lib/influxdb) : Same as V1, takes effect when the service is restarted.

> **Compared to V1** : (1) it uses IDs at the file level to distinguish specific storage buckets (2) it cannot replace data files during insertion, and even if it does, it will fail. However, it will not report an error if its data file is deleted after successful start. </br>
> **Conclusion**: (1) You can use the official command provided for cold backup, token configuration is required before backup on the server (2) File copy is possible, but you must restart the service, otherwise the data will be inaccurate.

### 4.2 New to V2

New concepts.

- bucket: All InfluxDB data is stored in a storage bucket. A bucket combines the concept of a database and a storage period (time each data point still exists for a duration). A bucket belongs to an organization

- bucket schema: Storage buckets with an explicit schema-type need to specify an explicit schema for each metric. The measure contains labels, fields and timestamps. The explicit schema restricts the shape of the data that can be written to the metric.

- organization: The InfluxDB organization is a workspace for a group of users. All dashboards, tasks, storage buckets, and users belong to an organization.

### 4.3 An Overview Table


| An overview Table     |         Influx 1.8         |                           influx 2.5                           |
| -------------- | :------------------------: | :------------------------------------------------------------: |
| Maintenance    |           - [x]            |                             - [x]                              |
| Database name  |          database          | Bucket <br/>(combination of a database and a retention policy) |
| Query Language | Flux & InfluxQL (partcial) |                        Flux & InfluxQL                         |
| Flux version | Needs action |                        Flux: 0.188.1                        |
| UI             |           - [ ]            |                             - [x]                              |


### 4.4 Something may be good to know (abstract from release notes)
- $INFLUX_TOKEN
- This release includes a breaking change to the format in which Time-Structured Merge Tree (TSM) and index data are stored on disk. Existing local data will not be queryable after upgrading to this release.
- main difference is ui
- Add tool `influxd inspect verify-wal`
- Added new storage inspection tool to verify TSM files
- Add jsonweb package for future JWT support.
- Added the JMeter Template dashboard.
- Extend influx cli user create to allow for organization ID and user passwords to be set on user.
- Annotate log messages with trace ID
- Add trace ID response header to query endpoint
- pkger `influx cli pkg command`
- influx secret
- Enforce DNS name compliance on the field in all resources.metadata.namepkger
- Add influxdb version to the InfluxDB v2 API endpoint./health
- Add InfluxDB v2 Listener, NSD, OPC-UA, and Windows Event Log to the Sources page.
