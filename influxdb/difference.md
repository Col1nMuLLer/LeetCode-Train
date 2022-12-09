[[_TOC_]]
# Main difference

## 1. Influx 1.8
InfluxDB 1.8 will continue to be maintained and receive defect fixes through the end of 2021. But InfluxDB 1.8 (and subsequent maintenance releases) will be the last official release on the 1. x line that will be built and distributed by InfluxData. However, the enterprise version is also in 1.x version. The break update has not been released. 

## 2. Influx 2.5
InfluxDB v2.5 is the latest stable version influxData released.


## Comparication

A key sum up about the difference. 
- Influx 1.8 doesn't support UI, we have to configure by ourselves. While, influx 2.5 supports UI, intergrade as a whole project.
- Influx 1.8 only supports partcial flux grammmar, mainly using sql-like query language. Influx 2.5 is mainly using flux query language, but supports some sql-like queries.
- To support sql in influxdb, we have to map from database/ retention policies to orgiganization/bucket. []<https://docs.influxdata.com/influxdb/v2.5/query-data/influxql/dbrp/#create-dbrp-mappings>
- File system layout differents:
- 

<https://docs.influxdata.com/influxdb/v2.5/query-data/influxql/#influxql-support>

| Heading 1      |         Influx 1.8         |                           influx 2.5                           |
| -------------- | :------------------------: | :------------------------------------------------------------: |
| Maintenance    |           - [x]            |                             - [x]                              |
| Database name  |          database          | Bucket <br/>(combination of a database and a retention policy) |
| Query Language | Flux & InfluxQL (partcial) |                        Flux & InfluxQL                         |
| UI             |           - [ ]            |                             - [x]                              |
| Maintenance    |          Cell A2           |                            Cell A3                             |
| Maintenance    |          Cell A2           |                            Cell A3                             |
| Maintenance    |          Cell A2           |                            Cell A3                             |
| Maintenance    |          Cell A2           |                            Cell A3                             |


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

